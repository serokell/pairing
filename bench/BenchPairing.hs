module BenchPairing (benchmarks) where

import Protolude

import Criterion.Main
import Curve
import Curve.Weierstrass
import ExtensionField
import GaloisField
import Pairing.Curve
import Pairing.Hash
import Pairing.Pairing
import PrimeField

-------------------------------------------------------------------------------
-- Benchmark Suite
-------------------------------------------------------------------------------

testFq_1:: Fq
testFq_1 = 5216004179354450092383934373463611881445186046129513844852096383579774061693

testFq_2 :: Fq
testFq_2 = 10757805228921058098980668000791497318123219899766237205512608761387909753942

testFr_1 :: Fr
testFr_1 = 2695867032484221784304381330654541950835516252740416091986521990446187260192

testFr_2 :: Fr
testFr_2 = 18361718052247311177607809961708721447660708684581683997732416822928487385039

testFq2_1 :: Fq2
testFq2_1 =
  toField [ 19908898611787582971615951530393785823319364696376311494770162270472288380562
          , 2444690988583914246674870181013910409542697083717824402984851238236041783759
          ]

testFq2_2 :: Fq2
testFq2_2 =
  toField [ 176307305890807650390915550856467756101144733976249050387177647283239486934
          , 9913547941088878400547309488585076816688958962210000330808066250849942240036
          ]

testFq6_1 :: Fq6
testFq6_1 =
  toField [ toField [ 8727269669017421992537561450387212506711577304101544328736696625792447584819
                    , 14548604791762199086915107662335514800873255588931510951007415299299859294564
                    ]
          , toField [ 12226353852518517213098257637254082040554292743096797524265221809863992104040
                    , 12690801089710533803594523982915673248220237967492611523932652691226365708512
                    ]
          , toField [ 18336930404004840796680535059992401039831316705513753839479258873269709495858
                    , 21634580953983557175729336703450663797341055784728343534694506874757389871868
                    ]
          ]

testFq6_2 :: Fq6
testFq6_2 =
  toField [ toField [ 21427158918811764040959407626476119248515601360702754918240300689672054041331
                    , 12750457256357562507331331307761996193149796736574153338180573114576232473092
                    ]
          , toField [ 19307896751125425658868292427117755307914453765471505616446813557567103424424
                    , 11511704315039881938763578963465960361806962511008317843374696569679546862720
                    ]
          , toField [ 16856354813335682789816416666746807604324955216244680818919639213184967817815
                    , 10563739714379631354612735346769824530666877338817980746884577737330686430079
                    ]
          ]

testFq12_1 :: Fq12
testFq12_1 =
  toField [ toField [ toField [ 4025484419428246835913352650763180341703148406593523188761836807196412398582
                              , 5087667423921547416057913184603782240965080921431854177822601074227980319916
                              ]
                    , toField [ 8868355606921194740459469119392835913522089996670570126495590065213716724895
                              , 12102922015173003259571598121107256676524158824223867520503152166796819430680
                              ]
                    , toField [ 92336131326695228787620679552727214674825150151172467042221065081506740785
                              , 5482141053831906120660063289735740072497978400199436576451083698548025220729
                              ]
                    ]          
          , toField [ toField [ 7642691434343136168639899684817459509291669149586986497725240920715691142493
                              , 1211355239100959901694672926661748059183573115580181831221700974591509515378
                              ]
                    , toField [ 20725578899076721876257429467489710434807801418821512117896292558010284413176
                              , 17642016461759614884877567642064231230128683506116557502360384546280794322728
                              ]
                    , toField [ 17449282511578147452934743657918270744212677919657988500433959352763226500950
                              , 1205855382909824928004884982625565310515751070464736233368671939944606335817
                              ]
                    ]
          ]
  
testFq12_2 :: Fq12
testFq12_2 =
  toField [ toField [ toField [ 495492586688946756331205475947141303903957329539236899715542920513774223311
                              , 9283314577619389303419433707421707208215462819919253486023883680690371740600
                              ]
                    , toField [ 11142072730721162663710262820927009044232748085260948776285443777221023820448
                              , 1275691922864139043351956162286567343365697673070760209966772441869205291758
                              ]
                    , toField [ 20007029371545157738471875537558122753684185825574273033359718514421878893242
                              , 9839139739201376418106411333971304469387172772449235880774992683057627654905
                              ]
                    ]          
          , toField [ toField [ 9503058454919356208294350412959497499007919434690988218543143506584310390240
                              , 19236630380322614936323642336645412102299542253751028194541390082750834966816
                              ]
                    , toField [ 18019769232924676175188431592335242333439728011993142930089933693043738917983
                              , 11549213142100201239212924317641009159759841794532519457441596987622070613872
                              ]
                    , toField [ 9656683724785441232932664175488314398614795173462019188529258009817332577664
                              , 20666848762667934776817320505559846916719041700736383328805334359135638079015
                              ]
                    ]
          ]

test_g1_1 :: G1
test_g1_1 = A
  4312786488925573964619847916436127219510912864504589785209181363209026354996
  16161347681839669251864665467703281411292235435048747094987907712909939880451

test_g1_2 :: G1
test_g1_2 = A
  19726521232578388179442373599749745040559336202710626280058164737015167983668
  8916054282623787320277288879860012889871960646705282620719014698393441239502

test_g2_1 :: G2
test_g2_1 = A
  ( toField
    [ 7883069657575422103991939149663123175414599384626279795595310520790051448551
    , 8346649071297262948544714173736482699128410021416543801035997871711276407441
    ]
  )
  ( toField
    [ 3343323372806643151863786479815504460125163176086666838570580800830972412274
    , 16795962876692295166012804782785252840345796645199573986777498170046508450267
    ]
  )

test_g2_2 :: G2
test_g2_2 = A
  ( toField
    [ 3243608945627071355385114622932133122087974401138668305336804137033580208808
    , 2403320200938270623472619242963887735471304641554649101656774729615146397552
    ]
  )
  ( toField
    [ 7590136428571280465598215063146990078553196689176860926896020586846726844869
    , 8036135660414384292776446470327730948618639044617118659780848199544099832559
    ]
  )

test_hash :: ByteString
test_hash = "TyqIPUBYojDVOnDPacfMGrGOzpaQDWD3KZCpqzLhpE4A3kRUCQFUx040Ok139J8WDVV2C99Sfge3G20Q8MEgu23giWmqRxqOc8pH"

benchmarks :: [Benchmark]
benchmarks =
  [ bgroup "Frobenius in Fq12"
    [ bench "naive"
      $ whnf (frobeniusNaive 1) testFq12_1
    , bench "fast"
      $ whnf (fq12Frobenius 1) testFq12_1
    ]
  , bgroup "Final exponentiation"
    [ bench "naive"
      $ whnf finalExponentiationNaive testFq12_1
    , bench "fast"
      $ whnf finalExponentiation testFq12_1
    ]
  , bgroup "Pairing"
    [ bench "without final exponentiation"
      $ whnf (uncurry atePairing) (gG1, gG2)
    , bench "with final exponentiation"
      $ whnf (uncurry reducedPairing) (gG1, gG2)
    ]
  , bgroup "Fq"
    [ bench "multiplication"
      $ whnf (uncurry (*)) (testFq_1, testFq_2)
    , bench "addition"
      $ whnf (uncurry (+)) (testFq_1, testFq_2)
    , bench "division"
      $ whnf (uncurry (/)) (testFq_1, testFq_2)
    , bench "exponentiation"
      $ whnf (pow testFq_1) (toInt testFr_1)
    , bench "inversion"
      $ whnf recip testFq_1
    , bench "square root"
      $ whnf sr testFq_1
    , bench "Y from X"
      $ whnf (yX test_g1_1) testFq_1
    ]
  , bgroup "Fr"
    [ bench "multiplication"
      $ whnf (uncurry (*)) (testFr_1, testFr_2)
    , bench "addition"
      $ whnf (uncurry (+)) (testFr_1, testFr_2)
    , bench "division"
      $ whnf (uncurry (/)) (testFr_1, testFr_2)
    , bench "inversion"
      $ whnf recip testFr_1
    , bench "exponentiation"
      $ whnf (pow testFr_1) (toInt testFr_2)
    ]
  , bgroup "Fq2"
    [ bench "multiplication"
      $ whnf (uncurry (*)) (testFq2_1, testFq2_2)
    , bench "addition"
      $ whnf (uncurry (+)) (testFq2_1, testFq2_2)
    , bench "division"
      $ whnf (uncurry (/)) (testFq2_1, testFq2_2)
    , bench "squaring"
      $ whnf (join (*)) testFq2_1
    , bench "exponentiation"
      $ whnf (pow testFq2_1) (toInt testFr_1)
    , bench "negation"
      $ whnf negate testFq2_1
    , bench "inversion"
      $ whnf recip testFq2_1
    , bench "conjugation"
      $ whnf conj testFq2_1
    , bench "square root"
      $ whnf sr testFq2_1
    , bench "Y from X"
      $ whnf (yX test_g2_1) testFq2_1
    ]
  , bgroup "Fq6"
    [ bench "multiplication"
      $ whnf (uncurry (*)) (testFq6_1, testFq6_2)
    , bench "addition"
      $ whnf (uncurry (+)) (testFq6_1, testFq6_2)
    , bench "division"
      $ whnf (uncurry (/)) (testFq6_1, testFq6_2)
    , bench "squaring"
      $ whnf (join (*)) testFq6_1
    , bench "negation"
      $ whnf negate testFq6_1
    , bench "inversion"
      $ whnf recip testFq6_1
    ]
  , bgroup "Fq12"
    [ bench "multiplication"
      $ whnf (uncurry (*)) (testFq12_1, testFq12_2)
    , bench "addition"
      $ whnf (uncurry (+)) (testFq12_1, testFq12_2)
    , bench "division"
      $ whnf (uncurry (/)) (testFq12_1, testFq12_2)
    , bench "negation"
      $ whnf negate testFq12_1
    , bench "inversion"
      $ whnf recip testFq12_1
    , bench "conjugation"
      $ whnf conj testFq12_1
    ]
  , bgroup "G1"
    [ bench "double"
      $ whnf dbl test_g1_1
    , bench "add"
      $ whnf (uncurry (<>)) (test_g1_1, test_g1_2)
    , bench "multiply"
      $ whnf (uncurry mul') (test_g1_1, 42)
    , bench "hashToG1"
      $ whnfIO (swEncBN test_hash)
    ]
  , bgroup "G2"
    [ bench "double"
      $ whnf dbl test_g2_1
    , bench "add"
      $ whnf (uncurry (<>)) (test_g2_1, test_g2_2)
    , bench "multiply"
      $ whnf (uncurry mul') (test_g2_1, 42)
    ]
  ]
