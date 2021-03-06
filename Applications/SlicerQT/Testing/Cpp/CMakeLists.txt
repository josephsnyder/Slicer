set(KIT ${KIT_LIBRARY_NAME})

if(Slicer_BUILD_CLI_SUPPORT)
  if(Slicer_BUILD_EMSegment)
    include_directories(
      ${EMSegment_SOURCE_DIR}
      ${RemoteIO_SOURCE_DIR} ${RemoteIO_BINARY_DIR})
  endif()
endif()

set(CMAKE_TESTDRIVER_BEFORE_TESTMAIN "DEBUG_LEAKS_ENABLE_EXIT_ERROR();" )
set(KIT_TEST_SRCS
  qSlicerAboutDialogTest1.cxx
  qSlicerMainWindowCoreTest1.cxx
  qSlicerMainWindowTest1.cxx
  qSlicerModuleFactoryManagerTest1.cxx
  )
if(Slicer_USE_PYTHONQT_WITH_TCL)
  list(APPEND KIT_TEST_SRCS qSlicerApplicationTpyclTest1.cxx)
  if(Slicer_BUILD_CLI_SUPPORT)
    if(Slicer_BUILD_EMSegment)
      list(APPEND KIT_TEST_SRCS qSlicerApplicationTpyclEMSegmentIntegrationTest.cxx)
    endif()
  endif()
endif()
create_test_sourcelist(Tests ${KIT}CxxTests.cxx
  ${KIT_TEST_SRCS}
  EXTRA_INCLUDE vtkMRMLDebugLeaksMacro.h
  )

set(target_libraries ${KIT})
if(Slicer_BUILD_CLI_SUPPORT)
  if(Slicer_BUILD_EMSegment)
    list(APPEND target_libraries vtkSlicerEMSegmentModuleLogic)
  endif()
endif()

add_executable(${KIT}CxxTests ${Tests})
target_link_libraries(${KIT}CxxTests  ${target_libraries})

#
# Add Tests
#

SIMPLE_TEST( qSlicerAboutDialogTest1 )
if(Slicer_USE_PYTHONQT_WITH_TCL)
  SIMPLE_TEST( qSlicerApplicationTpyclTest1 )
  set_tests_properties(qSlicerApplicationTpyclTest1 PROPERTIES PASS_REGULAR_EXPRESSION stringArray)
  if(Slicer_BUILD_CLI_SUPPORT)
    if(Slicer_BUILD_EMSegment)
      SIMPLE_TEST( qSlicerApplicationTpyclEMSegmentIntegrationTest $<TARGET_FILE:EMSegmentCommandLine>)
    endif()
  endif()
endif()
SIMPLE_TEST( qSlicerMainWindowCoreTest1 )
SIMPLE_TEST( qSlicerMainWindowTest1 )
SIMPLE_TEST( qSlicerModuleFactoryManagerTest1 )

#
# Application tests
#

add_test(
  NAME slicer_nomainwindow_DisableModulesCommandLineOptionsTest
  COMMAND ${Slicer_LAUNCH_COMMAND} $<TARGET_FILE:SlicerQT${SlicerQT_EXE_SUFFIX}>
  ${ARGN} --testing --disable-cli-modules --disable-loadable-modules --disable-scripted-loadable-modules
  )
set_tests_properties(
  slicer_nomainwindow_DisableModulesCommandLineOptionsTest
  PROPERTIES PASS_REGULAR_EXPRESSION "Number of loaded modules: 2"
  )

