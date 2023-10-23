module {
  mytoy.func @main() {
    %0 = mytoy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = mytoy.cast %0 : tensor<2x3xf64> to tensor<2x3xf64>
    %2 = mytoy.transpose(%1 : tensor<2x3xf64>) to tensor<3x2xf64>
    %3 = mytoy.mul %2, %2 : tensor<3x2xf64>
    mytoy.print %3 : tensor<3x2xf64>
    mytoy.return
  }
}
