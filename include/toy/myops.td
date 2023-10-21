#ifndef TOY_OPS
#define TOY_OPS

include "mlir/IR/OpBase.td"

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
      OpBuilder<(ins "DenseElementsAttr":$value), [{
        build($builder, $result, value.getType(), value);
      }]>,
      // Build a constant with a given constant floating-point value.
      OpBuilder<(ins "double":$value)>
    ];
}

def FuncOp : Toy_Op<"func"> {

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

  let skipDefaultBuilders = 1;

}

#endif // TOY_OPS