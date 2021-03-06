project(qSlicer${qt_module_name}ModuleWidgets)

#
# See CMake/SlicerMacroBuildModuleWidgets.cmake for details
#

set(module_widgets_name "${PROJECT_NAME}")

# The header '${module_widgets_name}Export.h' will be automatically configured.
set(module_widgets_export_directive "Q_SLICER_MODULE_VOLUMERENDERING_WIDGETS_EXPORT")

# Additional directories to include
set(module_widgets_include_directories
  ${vtkSlicerVolumeRenderingModuleMRML_SOURCE_DIR}
  ${vtkSlicerVolumeRenderingModuleMRML_BINARY_DIR}
  )

# Source files
set(module_widgets_SRCS
  qSlicerPresetComboBox.cxx
  qSlicerPresetComboBox.h
  qSlicerPresetComboBox_p.h
  qMRMLVolumePropertyNodeWidget.cxx
  qMRMLVolumePropertyNodeWidget.h
  )

# Headers that should run through moc
set(module_widgets_MOC_SRCS
  qSlicerPresetComboBox.h
  qSlicerPresetComboBox_p.h
  qMRMLVolumePropertyNodeWidget.h
  )

# UI files
set(module_widgets_UI_SRCS
  ../Resources/UI/qMRMLVolumePropertyNodeWidget.ui
  )

# Resources
set(module_widgets_resources
  )

# Additional Target libraries
set(module_widgets_target_libraries
  vtkSlicerVolumeRenderingModuleMRML
  )

SlicerMacroBuildModuleWidgets(
  NAME ${module_widgets_name}
  EXPORT_DIRECTIVE ${module_widgets_export_directive}
  INCLUDE_DIRECTORIES ${module_widgets_include_directories}
  SRCS ${module_widgets_SRCS}
  MOC_SRCS ${module_widgets_MOC_SRCS}
  UI_SRCS ${module_widgets_UI_SRCS}
  TARGET_LIBRARIES ${module_widgets_target_libraries}
  RESOURCES ${module_widgets_resources}
  )

# Qt Designer Plugins
add_subdirectory(DesignerPlugins)
