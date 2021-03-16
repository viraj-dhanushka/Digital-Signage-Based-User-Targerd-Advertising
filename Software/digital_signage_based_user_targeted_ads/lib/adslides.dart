class Adlist {
  List<List<String>> adSlides = [
    [
      'https://docs.google.com/presentation/d/12jNj9pCAosO-LXFWNS2VTySHJB61BQDLRH1-1h381zI/edit?usp=sharing',
      'https://docs.google.com/presentation/d/1xFO-aSyLuq5-O3ElnLB8lB1ABHE98RFGutrSGo8IjRg/edit?usp=sharing',
      'https://docs.google.com/presentation/d/1VpC_xHnGj1NV1UjERUHMFmwQRRl28Ji8_CWh6Rr0Xec/edit?usp=sharing',
      'https://docs.google.com/presentation/d/12jNj9pCAosO-LXFWNS2VTySHJB61BQDLRH1-1h381zI/edit?usp=sharing',
      'https://docs.google.com/presentation/d/12jNj9pCAosO-LXFWNS2VTySHJB61BQDLRH1-1h381zI/edit?usp=sharing',
    ],
    [
      'https://docs.google.com/presentation/d/12jNj9pCAosO-LXFWNS2VTySHJB61BQDLRH1-1h381zI/edit?usp=sharing',
      'https://docs.google.com/presentation/d/1cG2iULk3q7KgUI0QjtiVSp01b_W2lKqOlkjcq_xBCTY/edit?usp=sharing',
      'https://docs.google.com/presentation/d/18mXHQnWnD4OtAoFxjWrKU1tUR6nBWWHMppH2fQKyvio/edit?usp=sharing',
      'https://docs.google.com/presentation/d/12jNj9pCAosO-LXFWNS2VTySHJB61BQDLRH1-1h381zI/edit?usp=sharing',
      'https://docs.google.com/presentation/d/12jNj9pCAosO-LXFWNS2VTySHJB61BQDLRH1-1h381zI/edit?usp=sharing',
    ],
    [
      'https://docs.google.com/presentation/d/10VU4WIn163E-MkUOuPLyUH6CcqbyXez7DnOXxoo4ufw/edit?usp=sharing'
    ]
  ];

  List<List<String>> adPreviews = [
    [
      'https://docs.google.com/presentation/d/e/2PACX-1vSqMK6W5FcELm4mLn8H5eHo57C6KzmffKC2h6R_HsgaJyUOKjAamyDFY0OnfyxHD9vnKX5hKCAHK5ag/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vQ_08Rg6fD76TwWhCkZtpcnZV9fenokNVFS3qZB_ET4VT_XRwbJ8m6glftXxO_KkesJjI3hSSwshBwy/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vTXsH3v-HsM-OCDu37qFW-dRJ3zYiyhVI8BLHbwv5BVVX1U64nothO0OUQb6RhZaMcNgaLntH9v0Nls/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vSqMK6W5FcELm4mLn8H5eHo57C6KzmffKC2h6R_HsgaJyUOKjAamyDFY0OnfyxHD9vnKX5hKCAHK5ag/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vSqMK6W5FcELm4mLn8H5eHo57C6KzmffKC2h6R_HsgaJyUOKjAamyDFY0OnfyxHD9vnKX5hKCAHK5ag/pub?start=true&loop=true&delayms=3000',
    ],
    [
      'https://docs.google.com/presentation/d/e/2PACX-1vSqMK6W5FcELm4mLn8H5eHo57C6KzmffKC2h6R_HsgaJyUOKjAamyDFY0OnfyxHD9vnKX5hKCAHK5ag/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vQSfEVaOqFgEW3dI1A6mcAMeWv6IWRlgEssaTYSBJ3F-aVEouapLdUCLK-rdcHAp5hkswqSDmZqenCG/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vQu-JFOeZyh5Ci7ZURUe_NlW4ZOS2HYAMG0mWqlIp32wYWvnjn_qrwl1WDmudvV95z0dkxdvouUlofR/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vSqMK6W5FcELm4mLn8H5eHo57C6KzmffKC2h6R_HsgaJyUOKjAamyDFY0OnfyxHD9vnKX5hKCAHK5ag/pub?start=true&loop=true&delayms=3000',
      'https://docs.google.com/presentation/d/e/2PACX-1vSqMK6W5FcELm4mLn8H5eHo57C6KzmffKC2h6R_HsgaJyUOKjAamyDFY0OnfyxHD9vnKX5hKCAHK5ag/pub?start=true&loop=true&delayms=3000',
    ],
    [
      'https://docs.google.com/presentation/d/e/2PACX-1vT_jiaWYIqNXIomiqOHcT3mERf-lxJsin-Q4tOK4bxejttQ190wiQCcbdEcSSw7YyNzbOrAlCaaM7Sm/pub?start=true&loop=true&delayms=3000'
    ]
  ];

  String selectAd(int index1, int index2) {
    return adSlides[index1][index2];
  }

  String selectPreview(int index1, int index2) {
    return adPreviews[index1][index2];
  }
}
