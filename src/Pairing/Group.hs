{-# OPTIONS_GHC -fno-warn-orphans #-}

-- | Definitions of the groups the pairing is defined on
module Pairing.Group
  ( CyclicGroup(..)
  , G1
  , G2
  , GT
  , b1
  , b2
  , g1
  , g2
  , groupFromX
  , hashToG1
  , isInGT
  , isOnCurveG1
  , isOnCurveG2
  , fromByteStringG1
  , fromByteStringG2
  , fromByteStringGT
  ) where

import Protolude

import Control.Monad.Random (MonadRandom)
import Data.Semigroup ((<>))
import ExtensionField (toField)
import GaloisField (GaloisField(..))
import PrimeField (toInt)
import Test.QuickCheck (Arbitrary(..), Gen)
import Pairing.CyclicGroup
import Pairing.Fq
import Pairing.Hash
import Pairing.Params
import Pairing.Point
import Pairing.Serialize.Types

-- | G1 is E(Fq) defined by y^2 = x^3 + b
type G1 = Point Fq

-- | G2 is E'(Fq2) defined by y^2 = x^3 + b / xi
type G2 = Point Fq2

-- | GT is subgroup of _r-th roots of unity of the multiplicative
-- group of Fq12
type GT = Fq12

instance Semigroup G1 where
  (<>) = gAdd

instance Semigroup G2 where
  (<>) = gAdd

instance Semigroup GT where
  (<>) = (*)

instance Monoid G1 where
  mappend = gAdd
  mempty = Infinity

instance CyclicGroup G1 where
  generator = g1
  order _ = _r
  expn a b = gMul a (asInteger b)
  inverse = gNeg
  random = randomG1

instance Validate G1 where
  isValidElement = isOnCurveG1

instance Monoid G2 where
  mappend = gAdd
  mempty = Infinity

instance CyclicGroup G2 where
  generator = g2
  order _ = _r
  expn a b = gMul a (asInteger b)
  inverse = gNeg
  random = randomG2

instance Validate G2 where
  isValidElement = isOnCurveG2

instance Monoid GT where
  mappend = (*)
  mempty = 1

instance CyclicGroup GT where
  generator = panic "not implemented." -- this should be the _r-th primitive root of unity
  order = panic "not implemented." -- should be a factor of _r
  expn a b = pow a (asInteger b)
  inverse = recip
  random = rnd

instance Validate GT where
  isValidElement = isInGT

-- | Generator for G1
g1 :: G1
g1 = Point 1 2

-- | Generator for G2
g2 :: G2
g2 = Point x y
  where
    x = toField
      [ 10857046999023057135944570762232829481370756359578518086990519993285655852781
      , 11559732032986387107991004021392285783925812861821192530917403151452391805634 ]

    y = toField
      [ 8495653923123431417604973247489272438418190587263600148770280649306958101930
      , 4082367875863433681332203403145435568316851327593401208105741076214120093531 ]

-- | Test whether a value in G1 satisfies the corresponding curve
-- equation
isOnCurveG1 :: G1 -> Bool
isOnCurveG1 Infinity    = True
isOnCurveG1 (Point x y) = pow y 2 == pow x 3 + fromInteger _b

-- | Test whether a value in G2 satisfies the corresponding curve
-- equation
isOnCurveG2 :: G2 -> Bool
isOnCurveG2 Infinity    = True
isOnCurveG2 (Point x y) = pow y 2 == pow x 3 + toField [fromInteger _b] / xi

-- | Test whether a value is an _r-th root of unity
isInGT :: GT -> Bool
isInGT f = pow f _r == 1

-- | Parameter for curve on Fq
b1 :: Fq
b1 = fromInteger _b

-- | Parameter for twisted curve over Fq2
b2 :: Fq2
b2 = toField [b1] / xi

-------------------------------------------------------------------------------
-- Generators
-------------------------------------------------------------------------------

instance Arbitrary G1 where
  arbitrary = gMul g1 . abs <$> (arbitrary :: Gen Integer)

instance Arbitrary G2 where
  arbitrary = gMul g2 . abs <$> (arbitrary :: Gen Integer)

hashToG1 :: MonadRandom m => ByteString -> m (Maybe G1)
hashToG1 = swEncBN

randomG1 :: forall m . MonadRandom m => m G1
randomG1 = expn generator <$> (rnd :: m Fq)

randomG2 :: forall m . MonadRandom m => m G2
randomG2 = expn generator <$> (rnd :: m Fq)

groupFromX :: (Validate (Point a), FromX a) => (a -> a -> a) -> a -> Maybe (Point a)
groupFromX checkF x = do
  y <- yFromX x checkF
  if isValidElement (Point x y) then Just (Point x y) else Nothing

fromByteStringG1 :: (FromSerialisedForm u) => u -> LByteString -> Either Text G1
fromByteStringG1 unser = unserializePoint unser g1 . toSL

fromByteStringG2 :: (FromSerialisedForm u) => u -> LByteString -> Either Text G2
fromByteStringG2 unser = unserializePoint unser g2 . toSL

fromByteStringGT :: (FromUncompressedForm u) => u -> LByteString -> Either Text GT
fromByteStringGT unser = unserialize unser 1 . toSL
