#!/usr/bin/env mafia
{-# SUBMODULE ambiata/p@3ea83a82b058ba2e1dd216d9e7832fd49cf33dbd #-}
{-# PACKAGE ambiata-p #-}
{-# PACKAGE containers #-}
{-# PACKAGE text #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-unrecognised-pragmas #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}


import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import           Data.Set  (Set)
import qualified Data.Set as S
import qualified Data.Text as T
import qualified Data.Text.IO as T

import           P

import           System.IO (IO)
import qualified System.IO as IO
