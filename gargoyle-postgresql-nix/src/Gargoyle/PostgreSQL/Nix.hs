{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
module Gargoyle.PostgreSQL.Nix where

import Data.ByteString (ByteString)

import Gargoyle
import Gargoyle.PostgreSQL

import System.Directory (findExecutable)
import System.Which

postgresNix :: IO (Gargoyle FilePath ByteString)
postgresNix = do
  monitor <- findExecutable "gargoyle-nix-postgres-monitor"
  let monitorPath = maybe "gargoyle-nix-postgres-monitor" id monitor
  return $ (mkPostgresGargoyle $(staticWhich "pg_ctl") shutdownPostgresFast)
    { _gargoyle_exec = monitorPath
    }
