#
# tpycl.tcl is the tcl support code to allow calling of python-wrapped
# vtk code from tcl scripts.
#
# all support code is in the ::tpycl namespace
#
# to the extent possible this code emulates vtk's tcl wrapping so no
# source modification is required in the scripts
#

if { [info command ::tpycl::tcl_package] == "" } {
  # rename the 'package' command first time script is sourced
  rename ::package ::tpycl::tcl_package
}

proc ::package {option args} {
  # special purpose version of the package command to import vtk
  # - not realy general pupose - scripts that make extensive use of tpycl
  #   should be aware of things they want to get from python and
  #   call py_package directly
  if { $option == "require" && $args == "vtk" } {
    py_package vtk
    return [string range [py_eval "vtk.vtkVersion().GetVTKVersion()"] 1 end-1]
  } else {
    return [eval ::tpycl::tcl_package $option $args]
  }
}

if { [info command ::tpycl::tcl_after] == "" } {
  # rename the 'after' command first time script is sourced
  rename ::after ::tpycl::tcl_after
}

set ::after_warning ""
proc ::after {args} {
  # special purpose version of the after command to use 
  # an alternate event queue (probably Qt)
  if { $::after_warning == "" } {
    puts "TODO: need to handle after events"
    puts "TODO: not hanlding: \"$args\""
    set ::after_warning "done"
  }
  return "after0"
}

namespace eval tpycl {

  proc registerClass {className pyConstructor} {
    # create a proc in the global namespace that acts as the 
    # instantiator for the given class (this is called from the python
    # code for each class imported from the module)
    proc ::$className {args} [format "tpycl::instantiator $className $pyConstructor $%s" args]
  }

  proc uniqueInstanceName { className } {
    # make a unique command name
    # Not a super-efficient way, but workable:
    for {set i 0} {$i > -1} {incr i} {
      set instanceName $className$i
      if { [info command $instanceName] == "" } {
        break
      }
    }
    return $instanceName
  }

  proc instantiator {className pyConstructor arg} {
    # this will create a new instance of the class with the given name
    # and acts pretty much just like the vtk wrapping
    switch $arg {
      "ListInstances" {
        # does not account for non-autogenerated classes
        return [info command $className0x*]
      }
      "New" {
        set instanceName [tpycl::uniqueInstanceName $className]
      }
      default {
        set instanceName $arg
      }
    }
    # call the constructor - py_eval automatically 
    # creates an instance wrapper based on the classname
    # and the pointer
    set pyInstanceName [py_eval "$pyConstructor\(\)"]
    if { $arg == "New" } {
      set instanceName $pyInstanceName
    } else {
      # if the caller specified a name, create an alias proc for it
      proc ::$instanceName {args} [format "tpycl::methodCaller $pyInstanceName $%s" args]
    }
    return $instanceName
  }

  proc methodCaller {instanceName args} {
    # call to python to execute the method for this instance
    set args [lindex $args 0]
    set method [lindex $args 0]
    set args [lrange $args 1 end]

    # construct a python command with the args
    # TODO: deal with special cases in a more general way
    switch $method {
      "IsA" {
        set fmt "$instanceName.IsA('%s')"
        set pycmd [eval format $fmt $args]
      } 
      "Delete" {
        py_del "$instanceName"
        rename ::$instanceName ""
        return
      } 


      default {
        set doc [py_eval "__tmpdoc = $instanceName.$method.__doc__"]
        set types [py_eval "__tmpdoc\[__tmpdoc.find('(')+1:__tmpdoc.find(')')\]"]

        set tuple 0
        if { [string range $types 0 1] == "'(" } {
          # TODO: need more robust type parsing
          set tuple 1
        }

        if { $types == "''" } {
          set types ""
        }
        if { [llength $args] != [llength $types] } {
          # TODO: check for non matching args here
          # - complication is multiple sinatures
          # error "$instanceName $method called with \"$args\" but method needs \"$types\" (according to $doc)"
        }

        # avoid trying to set "$var(" as tcl will 
        # try to treat it as an array reference
        set pycmd [format "$instanceName.$method%s" "("]
        foreach arg $args { 
          set type [lindex $types 0]
          set types [lrange $types 1 end]
          if { ![py_type $arg] } {
            if { [string match "'vtk*" $type] && $arg == "" } {
              set arg "None"
            } else {
              # python doesn't understand the argument, and we don't know what type it is,
              # so assume it is a string
              if { $arg != "" } {
                set arg '$arg'
              }
            }
          }
          if { [string index $pycmd end] != "(" } {
            # if not at start of arg list, add a comma
            set pycmd "$pycmd,"
          } else {
            if { $tuple } {
              # append a paren but don't look like an array while doing it
              set pycmd [format "$pycmd%s" "("]
            }
          }
          set pycmd "$pycmd$arg"
        }
        set pycmd "$pycmd)"
        if { $args != "" && $tuple } {
          set pycmd "$pycmd)"
        }
      }
    }

    # execute the command
    set pyresult [py_eval $pycmd]
    if { $pyresult == "None" } {
      # if no return value, return nothing
      return
    }
    if [string match (*) $pyresult] {
      # if it's a tuple, strip the parens and make the commas into spaces
      # TODO: won't work for a tuple of strings with spaces in them
      regsub -all $pyresult , "" pyresult
      return [string range $pyresult 1 end-1]
    }
    if [string match '*' $pyresult] {
      # if it's a string, strip the quotes
      return [string range $pyresult 1 end-1]
    }
    if { [string index $pyresult end] == "L" && 
          [string is int [string range $pyresult 0 end-1]] } {
      # if it's a long int, return just the int part
      return [string range $pyresult 0 end-1]
    }
    # otherwise, it's probably a value or reference
    return $pyresult
  }

}

