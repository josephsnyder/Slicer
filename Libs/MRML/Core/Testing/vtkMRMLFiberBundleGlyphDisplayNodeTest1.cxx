/*=auto=========================================================================

  Portions (c) Copyright 2005 Brigham and Women's Hospital (BWH) 
  All Rights Reserved.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Program:   3D Slicer

=========================================================================auto=*/

#include "vtkMRMLFiberBundleGlyphDisplayNode.h"


#include "vtkMRMLCoreTestingMacros.h"

int vtkMRMLFiberBundleGlyphDisplayNodeTest1(int , char * [] )
{
  vtkSmartPointer< vtkMRMLFiberBundleGlyphDisplayNode > node1 = vtkSmartPointer< vtkMRMLFiberBundleGlyphDisplayNode >::New();

  EXERCISE_BASIC_OBJECT_METHODS( node1 );

  EXERCISE_BASIC_DISPLAY_MRML_METHODS(vtkMRMLFiberBundleGlyphDisplayNode, node1);
  
  return EXIT_SUCCESS;
}
