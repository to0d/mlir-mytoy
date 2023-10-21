#ifndef TOY_OPS
#define TOY_OPS

include "mlir/IR/OpBase.td"
include "mlir/IR/FunctionInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def MyToy_Dialect : Dialect {
  let name = "mytoy";
  let cppNamespace = "::mlir::mytoy";
}

class Toy_Op<string mnemonic, list<Trait> traits = []> :
    Op<MyToy_Dialect, mnemonic, traits>;

def ConstantOp : Toy_Op<"constant"> {
    let arguments = (ins F64ElementsAttr:$value);
    let results = (outs F64Tensor);
    let hasVerifier = 1;
    let builders = [
      // Build a constant with a given constant tensor value.
      OpBuilder<(ins "DenseElementsAttr":$value), [{
        build($_builder, $_state, value.getType(), value);
      }]>,

      // Build a constant with a given constant floating-point value.
      OpBuilder<(ins "double":$value)>
    ];
}

def FuncOp : Toy_Op<"func", [
    FunctionOpInterface, IsolatedFromAbove
  ]> {

  let arguments = (ins
    SymbolNameAttr:$sym_name,
    TypeAttrOf<FunctionType>:$function_type,
    OptionalAttr<DictArrayAttr>:$arg_attrs,
    OptionalAttr<DictArrayAttr>:$res_attrs
  );
  let regions = (region AnyRegion:$body);

  let builders = [OpBuilder<(ins
    "StringRef":$name, "FunctionType":$type,
    CArg<"ArrayRef<NamedAttribute>", "{}">:$attrs)
  >];

  let extraClassDeclaration = [{
    //===------------------------------------------------------------------===//
    // FunctionOpInterface Methods
    //===------------------------------------------------------------------===//

    /// Returns the argument types of this function.
    ArrayRef<Type> getArgumentTypes() { return getFunctionType().getInputs(); }

    /// Returns the result types of this function.
    ArrayRef<Type> getResultTypes() { return getFunctionType().getResults(); }
  }];

  let skipDefaultBuilders = 1;

}

#endif // TOY_OPS