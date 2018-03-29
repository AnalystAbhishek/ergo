(*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)

(* Built-in errors *)

Require Import String.
Require Import Jura.Common.Utils.JResult.
Require Import Jura.Backend.JuraBackend.

Section JError.
  Require Import List.

  Definition dispatch_lookup_error {A} : jresult A :=
    jfailure (CompilationError ("Cannot lookup created dispatch")).
  Definition dispatch_parameter_error {A} : jresult A :=
    jfailure (CompilationError ("No parameter type in dispatch")).
  Definition not_in_contract_error {A} : jresult A :=
    jfailure (CompilationError ("Cannot use 'contract' variable outside of a contract")).
  Definition not_in_clause_error {A} : jresult A :=
    jfailure (CompilationError ("Cannot use 'clause' variable outside of a clause")).

  Definition jura_default_package : string := "org.accordproject.jura".
  Definition jura_default_error_local_name : string := "Error".
  Definition jura_default_error_name : string :=
    jura_default_package ++ "." ++ jura_default_error_local_name.

  Definition enforce_error_content : JuraData.data :=
    JuraData.dbrand (jura_default_error_name::nil)
                    (JuraData.drec (("message"%string, JuraData.dstring "Enforce condition failed")::nil)).
  Definition enforce_error : jerror :=
    UserError enforce_error_content.

End JError.
