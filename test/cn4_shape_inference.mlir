// RUN: mytoy %s -emit=mlir -opt 2>&1 | FileCheck %s

// Check the result of inlining+shape inference on an input module.

mytoy.func private @multiply_transpose(%arg0: tensor<*xf64>, %arg1: tensor<*xf64>) -> tensor<*xf64> {
  %0 = mytoy.transpose(%arg0 : tensor<*xf64>) to tensor<*xf64>
  %1 = mytoy.transpose(%arg1 : tensor<*xf64>) to tensor<*xf64>
  %2 = mytoy.mul %0, %1 : tensor<*xf64>
  mytoy.return %2 : tensor<*xf64>
}
mytoy.func @main() {
  %0 = mytoy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
  %1 = mytoy.reshape(%0 : tensor<2x3xf64>) to tensor<2x3xf64>
  %2 = mytoy.constant dense<[1.000000e+00, 2.000000e+00, 3.000000e+00, 4.000000e+00, 5.000000e+00, 6.000000e+00]> : tensor<6xf64>
  %3 = mytoy.reshape(%2 : tensor<6xf64>) to tensor<2x3xf64>
  %4 = mytoy.generic_call @multiply_transpose(%1, %3) : (tensor<2x3xf64>, tensor<2x3xf64>) -> tensor<*xf64>
  %5 = mytoy.generic_call @multiply_transpose(%3, %1) : (tensor<2x3xf64>, tensor<2x3xf64>) -> tensor<*xf64>
  mytoy.print %5 : tensor<*xf64>
  mytoy.return
}

// CHECK-NOT: mytoy.func private @multiply_transpose
// CHECK-NOT: tensor<*xf64>

// CHECK-LABEL: mytoy.func @main()
// CHECK:         [[VAL_0:%.*]] = mytoy.constant dense<{{\[\[}}1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
// CHECK:         [[VAL_1:%.*]] = mytoy.transpose([[VAL_0]] : tensor<2x3xf64>) to tensor<3x2xf64>
// CHECK:         [[VAL_2:%.*]] = mytoy.mul [[VAL_1]], [[VAL_1]] : tensor<3x2xf64>
// CHECK:         mytoy.print [[VAL_2]] : tensor<3x2xf64>
// CHECK:         mytoy.return
