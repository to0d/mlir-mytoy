module {
  mytoy.func @main() {
    %0 = mytoy.constant dense<[1.000000e+00, 2.000000e+00]> : tensor<2xf64>
    %1 = mytoy.reshape(%0 : tensor<2xf64>) to tensor<2x1xf64>
    mytoy.print %1 : tensor<2x1xf64>
    mytoy.return
  }
}
