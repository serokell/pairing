module Pairing
  ( module Pairing
  ) where

import Group (Group)

-------------------------------------------------------------------------------
-- Types
-------------------------------------------------------------------------------

-- | Pairing of cryptographic groups.
class (Group g1, Group g2, Group gt) => Pairing g1 g2 gt where
  {-# MINIMAL pairing #-}

  -- | Computable non-degenerate bilinear map.
  pairing :: g1 -> g2 -> gt