module {
  mytoy.func @main() {
    %0 = mytoy.constant dense<[1.000000e+00, 2.000000e+00]> : tensor<2xf64>
    %1 = mytoy.reshape(%0 : tensor<2xf64>) to tensor<2x1xf64>
    %2 = mytoy.reshape(%1 : tensor<2x1xf64>) to tensor<2x1xf64>
    %3 = mytoy.reshape(%2 : tensor<2x1xf64>) to tensor<2x1xf64>
    mytoy.print %3 : tensor<2x1xf64>
    mytoy.return
  }
}
