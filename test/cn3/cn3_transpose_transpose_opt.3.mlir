module {
  mytoy.func @transpose_transpose(%arg0: tensor<*xf64>) -> tensor<*xf64> {
    %0 = mytoy.transpose(%arg0 : tensor<*xf64>) to tensor<*xf64>
    mytoy.return %arg0 : tensor<*xf64>
  }
  mytoy.func @main() {
    %0 = mytoy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = mytoy.reshape(%0 : tensor<2x3xf64>) to tensor<2x3xf64>
    %2 = mytoy.generic_call @transpose_transpose(%1) : (tensor<2x3xf64>) -> tensor<*xf64>
    mytoy.print %2 : tensor<*xf64>
    mytoy.return
  }
}
