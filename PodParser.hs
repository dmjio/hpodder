-- file: ch22/PodParser.hs
module PodParser where

import           Data.Char
import           Data.List
import           PodTypes
import           Text.XML.Light.Input

data PodItem = PodItem {itemtitle :: String,
                  enclosureurl    :: String
                  }
          deriving (Eq, Show, Read)

data Feed = Feed {channeltitle :: String,
                  items        :: [PodItem]}
            deriving (Eq, Show, Read)


