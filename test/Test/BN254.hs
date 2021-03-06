module Test.BN254 where

import Protolude

import Data.Curve.Weierstrass as C
import Data.Field.Galois as F
import Data.Pairing.BN254
import Test.Tasty
import Test.Tasty.HUnit

import Test.Curve
import Test.Field
import Test.Pairing

testBN254 :: TestTree
testBN254 = testGroup "BN254"
  [ testField "Fq" (witness :: Fq)
  , testField "Fq2" (witness :: Fq2)
  , testField "Fq6" (witness :: Fq6)
  , testField "Fq12" (witness :: Fq12)
  , testField "Fr" (witness :: Fr)
  , testCurve "G1" (C.gen :: G1')
  , testCurve "G2" (C.gen :: G2')
  , testUnity "GT" (F.gen :: GT')
  , testPairing (witness :: BN254)
  , testCase "Test vector" $ pairing g1 g2 @?= gt
  , testHashBN (witness :: BN254)
  ]

g1 :: G1 BN254
g1 = A
  0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd3
  0x15ed738c0e0a7c92e7845f96b2ae9c0a68a6a449e3538fc7ff3ebf7a5a18a2c4

g2 :: G2 BN254
g2 = A
  ( [ 0x6064e784db10e9051e52826e192715e8d7e478cb09a5e0012defa0694fbc7f5
    , 0x1014772f57bb9742735191cd5dcfe4ebbc04156b6878a0a7c9824f32ffb66e85
    ]
  )
  ( [ 0x58e1d5681b5b9e0074b0f9c8d2c68a069b920d74521e79765036d57666c5597
    , 0x21e2335f3354bb7922ffcc2f38d3323dd9453ac49b55441452aeaca147711b2
    ]
  )

gt :: GT BN254
gt = toU'
  [ [ [ 0x10227b2606c11f22f4b2dec3f69cee4332ebe2e8f869ea8ca9e6d45ce15bd110
      , 0x27d1c9dae835182b272bb25b47b0d871382c9c2765fd1f42e07edbe852830157
      ]
    , [ 0x1f5919cf59b218135aaeb137ac84c6ecf282feda6a8752ca291b7ec1d2f8bab4
      , 0x2b7e44680d35a6676223538d54abcd7bc2c54281bf0f5277c81cf5b114d3a345
      ]
    , [ 0x17e6d213292c2aa12ef3cc75aca8cb9cbd47d05086227db2dbd1262d3e89dbf0
      , 0x291a53fea204b470bb901fb184155facd6e3b44fad848d536386b73d6c31fd52
      ]
    ]
  , [ [ 0x2844ed362ecf2c491a471a18c2875fd727126a62c8151c356f81e02cff52f045
      , 0x2a8245d55a3b3f9deae9cca372912a31b88dc77cee06dfa10a717acbf758cbd5
      ]
    , [ 0x222ff2e20c4578e886027953a035cbd8784a9764bbcd353051ba9f02c4dce8ad
      , 0x8532a0a75fb0acdf508c3bdd4c7700efb3a9ae403818daad5937d9ffffaca45
      ]
    , [ 0x2e7e3a4aaef17a53de3c528319b426e35f53455107f49d7fe52de95849e7dcf6
      , 0x2ba2bc83434031012424aad830a35c459c40a0b7ce87735010db68c10b61ddcb
      ]
    ]
  ]
