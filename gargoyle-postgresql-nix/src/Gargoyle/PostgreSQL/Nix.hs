{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Gargoyle.PostgreSQL.Nix
-- Copyright   :  (c) Obsidian Systems LLC
-- License     :  BSD3
--
-- Maintainer  :  maintainer@obsidian.systems
--
-- Nix-integrated PostgreSQL 'Gargoyle'.
--
--   'postgresNix' creates a 'Gargoyle' that resolves the @pg_ctl@
--   binary path at compile time via 'staticWhich' and locates its
--   own monitor executable from the Nix-installed @bin/@ directory.
--   This avoids runtime PATH dependencies on PostgreSQL.
--
-----------------------------------------------------------------------------
module Gargoyle.PostgreSQL.Nix where

import Data.ByteString (ByteString)

import Gargoyle
import Gargoyle.PostgreSQL

import Paths_gargoyle_postgresql_nix
import System.Which

postgresNix :: IO (Gargoyle FilePath ByteString)
postgresNix = do
  bindir <- getBinDir
  return $ (mkPostgresGargoyle $(staticWhich "pg_ctl") shutdownPostgresFast)
    { _gargoyle_exec = bindir <> "/gargoyle-nix-postgres-monitor"
    }
