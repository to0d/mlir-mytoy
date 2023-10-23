module {
  mytoy.func @main() {
    %0 = mytoy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %1 = mytoy.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00]]> : tensor<2x3xf64>
    %2 = mytoy.cast %1 : tensor<2x3xf64> to tensor<*xf64>
    %3 = mytoy.cast %0 : tensor<2x3xf64> to tensor<*xf64>
    %4 = mytoy.transpose(%2 : tensor<*xf64>) to tensor<*xf64>
    %5 = mytoy.transpose(%3 : tensor<*xf64>) to tensor<*xf64>
    %6 = mytoy.mul %4, %5 : tensor<*xf64>
    mytoy.print %6 : tensor<*xf64>
    mytoy.return
  }
}
