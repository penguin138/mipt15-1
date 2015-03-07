{-# LANGUAGE OverloadedStrings #-}

import Control.Monad
import Network.HTTP.Conduit
import Data.Text.Encoding
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Char8 as C

(email, name) = ("torunova@phystech.edu", encodeUtf8 "Торунова А.С.") -- адрес почты и фамилия с инициалами

pascal :: Int -> Int -> Int
pascal c r =   if(c == 0 || c == r) then 1 else (pascal (c-1) (r-1)) + (pascal c (r-1))-- а тут решение

printIt :: Int -> C.ByteString
printIt n = C.pack $ show $ [pascal y x | x <- [0..n], y <- [0..x]]

main :: IO()
main = do
  initReq <- parseUrl "http://mipt.eu01.aws.af.cm/lab0"
  let req = urlEncodedBody [("email", email), ("name", name), ("lang", "haskell"), ("content", printIt 20)] $ initReq { method = "POST" }
  response <- withManager $ httpLbs req
  L.putStr $ responseBody response
