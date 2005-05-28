// -*- c++ -*-

// @HEADER
// ***********************************************************************
//
//            PyTrilinos.Epetra: Python Interface to Epetra
//                 Copyright (2005) Sandia Corporation
//
// Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive
// license for use of this work by or on behalf of the U.S. Government.
//
// This library is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 2.1 of the
// License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
// Questions? Contact Michael A. Heroux (maherou@sandia.gov)
//
// ***********************************************************************
// @HEADER

%module(package="PyTrilinos") Triutils

%{
// System includes
#include <iostream>
#include <sstream>
#include <vector>

#include "Epetra_Map.h"
#include "Epetra_CrsMatrix.h"
#include "Epetra_VbrMatrix.h"
#include "Trilinos_Util_CrsMatrixGallery.h"
#include "Trilinos_Util_Version.h"
#include "Epetra_NumPyVector.h"
void Trilinos_Util_ReadHb2Epetra(char *data_file,
				 const Epetra_Comm  &comm, 
				 Epetra_Map *& map, 
				 Epetra_CrsMatrix *& A, 
				 Epetra_Vector *& x, 
				 Epetra_Vector *& b,
				 Epetra_Vector *&xexact);
extern "C" {
  // on some MAC OS X with LAM/MPI _environ() is not found,
  // need to specify -Wl,-i_environ:_fake_environ as LDFLAGS
  void fake_environ() 
  {
     exit(EXIT_FAILURE); 
  }
}

%}

// Auto-documentation feature
%feature("autodoc", "1");

// rename
%rename Trilinos_Util_ReadHb2Epetra ReadHB;

// defining typemaps for ReadMatrix
%typemap(argout) (Epetra_Map*& OutMap,
                  Epetra_CrsMatrix*& OutMatrix,
                  Epetra_Vector*& OutX,
                  Epetra_Vector*& OutB,
                  Epetra_Vector*& OutXexact) 
{
  PyObject *oMap, *oMatrix, *oX, *oB, *oXexact;
  PyObject *o3;
  oMap = SWIG_NewPointerObj((void*)(*$1), SWIGTYPE_p_Epetra_Map, 1);
  oMatrix = SWIG_NewPointerObj((void*)(*$2), SWIGTYPE_p_Epetra_CrsMatrix, 1);
  oX = SWIG_NewPointerObj((void*)(*$3), SWIGTYPE_p_Epetra_Vector, 1);
  oB = SWIG_NewPointerObj((void*)(*$4), SWIGTYPE_p_Epetra_Vector, 1);
  oXexact = SWIG_NewPointerObj((void*)(*$5), SWIGTYPE_p_Epetra_Vector, 1);

  $result = oMap;
  if (!PyTuple_Check($result)) {
    PyObject *o2 = $result;
    $result = PyTuple_New(1);
    PyTuple_SetItem($target,0,o2);
  }
  // add matrix
  o3 = PyTuple_New(1);
  PyTuple_SetItem(o3,0,oMatrix);
  $result = PySequence_Concat($result,o3);
  // add X
  o3 = PyTuple_New(1);
  PyTuple_SetItem(o3,0,oX);
  $result = PySequence_Concat($result,o3);
  // add B
  o3 = PyTuple_New(1);
  PyTuple_SetItem(o3,0,oB);
  $result = PySequence_Concat($result,o3);
  // add oXexact
  o3 = PyTuple_New(1);
  PyTuple_SetItem(o3,0,oXexact);
  $result = PySequence_Concat($result,o3);
}
%typemap(in,numinputs=0) Epetra_Map *&OutMap(Epetra_Map* _map) {
    $1 = &_map;
}
%typemap(in,numinputs=0) Epetra_CrsMatrix *&OutMatrix(Epetra_CrsMatrix* _matrix) {
    $1 = &_matrix;
}
%typemap(in,numinputs=0) Epetra_Vector *&OutX(Epetra_Vector* _x) {
    $1 = &_x;
}
%typemap(in,numinputs=0) Epetra_Vector *&OutB(Epetra_Vector* _B) {
    $1 = &_B;
}
%typemap(in,numinputs=0) Epetra_Vector *&OutXexact(Epetra_Vector* _xexact) {
    $1 = &_xexact;
}
void Trilinos_Util_ReadHb2Epetra(char *data_file,
				 const Epetra_Comm  &comm, 
				 Epetra_Map *& OutMap, 
				 Epetra_CrsMatrix *& OutMatrix, 
				 Epetra_Vector *& OutX, 
				 Epetra_Vector *& OutB,
				 Epetra_Vector *& OutXexact);

// Epetra interface includes
using namespace std;
%import "Epetra.i"

// Triutils interface includes
%include "Trilinos_Util_CrsMatrixGallery.h"
%include "Trilinos_Util_Version.h"

// Python code
%pythoncode %{

  __version__ = Triutils_Version().split()[2]

%}
