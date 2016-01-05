/*==============================================================================

  Program: 3D Slicer

  Portions (c) Copyright 2015 Brigham and Women's Hospital (BWH) All Rights Reserved.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  This file was originally developed by Andras Lasso (PerkLab, Queen's
  University) and Kevin Wang (Princess Margaret Hospital, Toronto) and was
  supported through OCAIRO and the Applied Cancer Research Unit program of
  Cancer Care Ontario.

==============================================================================*/

#ifndef __vtkSlicerTablesLogic_h
#define __vtkSlicerTablesLogic_h

// Slicer includes
#include "vtkSlicerModuleLogic.h"

// MRML includes

// Tables includes
#include "vtkSRPlanTablesModuleLogicExport.h"

class vtkAbstractArray;
class vtkMRMLTableNode;

/// \ingroup Slicer_QtModules_ExtensionTemplate
/// \brief Slicer logic class for double array manipulation
/// This class manages the logic associated with reading, saving,
/// and changing propertied of the double array nodes
class VTK_SRPlan_TABLES_MODULE_LOGIC_EXPORT vtkSlicerTablesLogic
  : public vtkSlicerModuleLogic
{
public:

  static vtkSlicerTablesLogic *New();
  vtkTypeMacro(vtkSlicerTablesLogic, vtkSlicerModuleLogic);
  void PrintSelf(ostream& os, vtkIndent indent);

  vtkMRMLTableNode* AddTable(const char* fileName, const char* name = 0);

protected:
  vtkSlicerTablesLogic();
  virtual ~vtkSlicerTablesLogic();

private:
  vtkSlicerTablesLogic(const vtkSlicerTablesLogic&); // Not implemented
  void operator=(const vtkSlicerTablesLogic&);               // Not implemented
};

#endif
