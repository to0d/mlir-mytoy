// RUN: mytoy %s -emit=mlir -opt 2>&1 | FileCheck %s

mytoy.func @main() {
  %0 = mytoy.struct_constant [
    [dense<4.000000e+00> : tensor<2x2xf64>], dense<4.000000e+00> : tensor<2x2xf64>
  ] : !mytoy.struct<!mytoy.struct<tensor<*xf64>>, tensor<*xf64>>
  %1 = mytoy.struct_access %0[0] : !mytoy.struct<!mytoy.struct<tensor<*xf64>>, tensor<*xf64>> -> !mytoy.struct<tensor<*xf64>>
  %2 = mytoy.struct_access %1[0] : !mytoy.struct<tensor<*xf64>> -> tensor<*xf64>
  mytoy.print %2 : tensor<*xf64>
  mytoy.return
}

// CHECK-LABEL: mytoy.func @main
// CHECK-NEXT: %[[CST:.*]] = mytoy.constant dense<4.0
// CHECK-NEXT: mytoy.print %[[CST]]
