module {
  mytoy.func @main() {
    %0 = mytoy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = mytoy.transpose(%0 : tensor<2x3xf64>) to tensor<3x2xf64>
    %2 = mytoy.mul %1, %1 : tensor<3x2xf64>
    mytoy.print %2 : tensor<3x2xf64>
    mytoy.return
  }
}
