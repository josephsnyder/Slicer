if(BUILD_TESTING)
  # Code specfic to Slicer testing is added here.
  set(KIT ${PROJECT_NAME})
  set(CMAKE_TESTDRIVER_BEFORE_TESTMAIN "DEBUG_LEAKS_ENABLE_EXIT_ERROR();" )
  include_directories(${CMAKE_CURRENT_BINARY_DIR})
  set(KIT_TEST_SRCS
    qSlicerAbstractModuleTest1.cxx
    qSlicerAbstractModuleWidgetTest1.cxx
    qSlicerApplicationTest1.cxx
    qSlicerDataDialogTest1.cxx
    qSlicerDirectoryListViewTest1.cxx
    qSlicerLayoutManagerTest1.cxx
    qSlicerLoadableModuleTest1.cxx
    qSlicerModulePanelTest1.cxx
    qSlicerWidgetTest1.cxx
    qSlicerWidgetTest2.cxx
    )
  if(Slicer_BUILD_EXTENSIONMANAGER_SUPPORT)
    list(APPEND KIT_TEST_SRCS
      )
  endif()
  if(Slicer_USE_PYTHONQT)
    list(APPEND KIT_TEST_SRCS
      qSlicerPythonManagerWithoutApplicationTest.cxx
      qSlicerScriptedLoadableModuleTest.cxx
      qSlicerScriptedLoadableModuleWidgetTest.cxx
      )
  endif()
  create_test_sourcelist(Tests ${KIT}CxxTests.cxx
    ${KIT_TEST_SRCS}
    EXTRA_INCLUDE vtkMRMLDebugLeaksMacro.h
    )

  if(Slicer_USE_PYTHONQT)
    QT4_GENERATE_MOCS(
      qSlicerPythonManagerWithoutApplicationTest.cxx
      qSlicerScriptedLoadableModuleTest.cxx
      qSlicerScriptedLoadableModuleWidgetTest.cxx
      )
  endif()

  QT4_ADD_RESOURCES(Tests Resources/${KIT}Testing.qrc)

  add_executable(${KIT}CxxTests ${Tests})
  target_link_libraries(${KIT}CxxTests ${KIT})
  set_target_properties(${KIT}CxxTests PROPERTIES LABELS ${KIT})

  #
  # Add Tests
  #

  SIMPLE_TEST( qSlicerApplicationTest1 )
  SIMPLE_TEST( qSlicerAbstractModuleTest1 )
  SIMPLE_TEST( qSlicerAbstractModuleWidgetTest1 )
  SIMPLE_TEST( qSlicerDataDialogTest1 )
  SIMPLE_TEST( qSlicerDirectoryListViewTest1 )
  SIMPLE_TEST( qSlicerLayoutManagerTest1 )
  SIMPLE_TEST( qSlicerLoadableModuleTest1 )
  SIMPLE_TEST( qSlicerModulePanelTest1 )
  SIMPLE_TEST( qSlicerWidgetTest1 )
  SIMPLE_TEST( qSlicerWidgetTest2 )

  if(Slicer_BUILD_EXTENSIONMANAGER_SUPPORT)
  endif()

  if(Slicer_USE_PYTHONQT)
    SIMPLE_TEST( qSlicerPythonManagerWithoutApplicationTest )
    SIMPLE_TEST( qSlicerScriptedLoadableModuleTest )
    SIMPLE_TEST( qSlicerScriptedLoadableModuleWidgetTest )
  endif()

endif()

#
# Test templates - Common to both Slicer and the extensions
#

set(Slicer_CXX_MODULE_TEST_TEMPLATES_DIR ${CMAKE_CURRENT_SOURCE_DIR}
  CACHE INTERNAL "Path to cxx test templates directory.")

# Install the file so that project building against the 'installed tree' can reference it.
if(NOT Slicer_INSTALL_NO_DEVELOPMENT)
  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/qSlicerUtilsTest1.cxx.in
    DESTINATION ${Slicer_INSTALL_SHARE_DIR} COMPONENT Development
    )
endif()
