/*==============================================================================

  Program: 3D Slicer

  Copyright (c) Kitware Inc.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  This file was originally developed by Jean-Christophe Fillion-Robin, Kitware Inc.
  and was partially funded by NIH grant 3P41RR013218-12S1

==============================================================================*/

#ifndef __qSlicerMouseModeToolBar_h
#define __qSlicerMouseModeToolBar_h

// Qt includes
#include <QToolBar>
#include <QMenu>

// CTK includes
#include "qSlicerBaseQTGUIExport.h"

class qSlicerMouseModeToolBarPrivate;
class vtkMRMLScene;
class vtkSlicerApplicationLogic;

///
/// qSlicerMouseModeToolBar is a toolbar that can be used to switch between 
/// mouse modes: PickMode, PickModePersistent, PlaceMode, PlaceModePersistent, TransformMode
/// \note The toolbar expects qSlicerCoreApplication::mrmlApplicationLogic() to return a valid object
class Q_SLICER_BASE_QTGUI_EXPORT qSlicerMouseModeToolBar: public QToolBar
{
  Q_OBJECT
public:
  typedef QToolBar Superclass;

  /// Constructor
  /// Title is the name of the toolbar (can appear using right click on the toolbar area)
  qSlicerMouseModeToolBar(const QString& title, QWidget* parent = 0);
  qSlicerMouseModeToolBar(QWidget* parent = 0);
  virtual ~qSlicerMouseModeToolBar();

public slots:

  void setApplicationLogic(vtkSlicerApplicationLogic* logic);

  void setMRMLScene(vtkMRMLScene* newScene);

  void switchToViewTransformMode();

  void changeCursorTo(QCursor cursor);

  /// Switch to placing items of annotationID type
  void switchPlaceMode();

  /// Update the interaction node's persistent place mode from the checkbox
  void onPersistenceCheckBoxStateChanged(int state);
protected:
  QScopedPointer<qSlicerMouseModeToolBarPrivate> d_ptr;

  bool isActionTextInMenu(QString actionText, QMenu *menu);
private:
  Q_DECLARE_PRIVATE(qSlicerMouseModeToolBar);
  Q_DISABLE_COPY(qSlicerMouseModeToolBar);
};

#endif
