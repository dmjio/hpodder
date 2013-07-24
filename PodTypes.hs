{-# LANGUAGE DeriveFoldable    #-}
{-# LANGUAGE DeriveFunctor     #-}
{-# LANGUAGE DeriveTraversable #-}

module PodTypes where

-- import           Data.Char
-- import           Data.Foldable    (Foldable (foldMap))
-- import           Data.IORef
-- import           Data.Traversable (Traversable (traverse))

-- data Tree a = Empty | Node a (Tree a) (Tree a) deriving (Functor, Foldable, Traversable, Show)

-- tree = Node 0 (Node 0 (Node 0 Empty Empty) (Node 0 Empty Empty)) Empty
-- t0 = Empty
-- t1 = Node 1 Empty Empty
-- t3 = Node 2 (Node 1 Empty Empty) (Node 3 Empty Empty)

data Podcast = Podcast
    { castId  :: Integer -- ^ Numeric ID for this podcast
    , castURL :: String -- ^ Its feed URL
    } deriving (Show, Eq, Read)

data Episode = Episode
    { epId   :: Integer -- ^ Numeric ID for this episode
    , epCast :: Podcast -- ^ The podcast
    , epURL  :: String  -- ^ Download URL
    , epDone :: Bool  -- ^ Whether or not we are done with this ep
    } deriving (Show, Eq, Read)






























