# Module name (usually identique to the directory name)
set(qt_module_name "Models")

set(qt_module_export_directive "Q_SLICER_QTMODULES_MODELS_EXPORT")

# Build module sub libraries
add_subdirectory(Logic)
add_subdirectory(Widgets)

# Additional includes - Current_{source,binary} and Slicer_{Libs,Base} already included
# Is used by the Plugins and Testing directories
set(qt_module_include_directories
  ${CMAKE_CURRENT_SOURCE_DIR}/Logic
  ${CMAKE_CURRENT_BINARY_DIR}/Logic
  ${CMAKE_CURRENT_SOURCE_DIR}/Widgets
  ${CMAKE_CURRENT_BINARY_DIR}/Widgets
  )

# Source files
set(qt_module_SRCS
  qSlicerModelsIO.cxx
  qSlicerModelsIO.h
  qSlicerModelsModule.cxx
  qSlicerModelsModule.h
  qSlicerModelsModuleWidget.cxx
  qSlicerModelsModuleWidget.h
  qSlicerScalarOverlayIO.cxx
  qSlicerScalarOverlayIO.h
  qSlicerScalarOverlayIOOptionsWidget.cxx
  qSlicerScalarOverlayIOOptionsWidget.h
  )

# Headers that should run through moc
set(qt_module_MOC_SRCS
  qSlicerModelsIO.h
  qSlicerModelsModule.h
  qSlicerModelsModuleWidget.h
  qSlicerScalarOverlayIO.h
  qSlicerScalarOverlayIOOptionsWidget.h
  )

# UI files
set(qt_module_UI_SRCS
  Resources/UI/qSlicerModelsModule.ui
  Resources/UI/qSlicerScalarOverlayIOOptionsWidget.ui
)

# Additional Target libraries
set(qt_module_target_libraries
  qSlicerModelsModuleWidgets
  vtkSlicerModelsModuleLogic
  )

# Resources
set(qt_module_resources
  Resources/qSlicerModelsModule.qrc
)

slicerMacroBuildQtModule(
  NAME ${qt_module_name}
  EXPORT_DIRECTIVE ${qt_module_export_directive}
  INCLUDE_DIRECTORIES ${qt_module_include_directories}
  SRCS ${qt_module_SRCS}
  MOC_SRCS ${qt_module_MOC_SRCS}
  UI_SRCS ${qt_module_UI_SRCS}
  TARGET_LIBRARIES ${qt_module_target_libraries}
  RESOURCES ${qt_module_resources}
  )

if(BUILD_TESTING)
  add_subdirectory(Testing)
endif()

