{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE UnicodeSyntax     #-}

module Index
  ( HasIndex( Elem, Indexer, index ), (!), (!!)

  , tests
  )
where

import Prelude  ( fromIntegral )

-- base --------------------------------

import Data.Eq        ( Eq )
import Data.Function  ( ($), flip )
import Data.Maybe     ( Maybe( Just ) )
import Data.String    ( String )
import System.Exit    ( ExitCode )
import System.IO      ( IO )

-- hashable ----------------------------

import Data.Hashable  ( Hashable )

-- more-unicode ------------------------

import Data.MoreUnicode.Natural  ( ℕ )

-- safe --------------------------------

import Safe  ( atMay )

-- tasty -------------------------------

import Test.Tasty  ( TestTree, testGroup )

-- tasty-hunit -------------------------

import Test.Tasty.HUnit  ( (@=?), testCase )

-- tasty-plus --------------------------

import TastyPlus  ( runTestsP, runTestsReplay, runTestTree )

-- unordered-containers ----------------

import Data.HashMap.Strict  ( HashMap, (!?) )

------------------------------------------------------------
--                     local imports                      --
------------------------------------------------------------

class HasIndex χ where
  type Indexer χ
  type Elem    χ
  index ∷ Indexer χ → χ → Maybe (Elem χ)

infixl 9 !
(!) ∷ HasIndex χ ⇒ Indexer χ → χ → Maybe (Elem χ)
i ! xs = index i xs

infixl 9 !!
(!!) ∷ HasIndex χ ⇒ χ → Indexer χ → Maybe (Elem χ)
(!!) = flip (!)

instance HasIndex [α] where
  type Indexer [α] = ℕ
  type Elem    [α] = α
  index i xs = atMay xs (fromIntegral i)

instance (Eq α, Hashable α) ⇒ HasIndex (HashMap α β) where
  type Indexer (HashMap α β) = α
  type Elem    (HashMap α β) = β
  index = flip (!?)

--------------------------------------------------------------------------------
--                                   tests                                    --
--------------------------------------------------------------------------------

tests ∷ TestTree
tests =
  testGroup "Index"
            [ testCase "!"     $ Just (13 ∷ ℕ) @=? 6 ! [1,1,2,3,5,8,13,21]
            , testCase "index" $ Just ( 8 ∷ ℕ) @=? index 5 [1,1,2,3,5,8,13,21]
            , testCase "!!"    $ Just (13 ∷ ℕ) @=? [1,1,2,3,5,8,13,21] !! 6
            ]

----------------------------------------

_test ∷ IO ExitCode
_test = runTestTree tests

--------------------

_tests ∷ String → IO ExitCode
_tests = runTestsP tests

_testr ∷ String → ℕ → IO ExitCode
_testr = runTestsReplay tests

-- that's all, folks! ----------------------------------------------------------
