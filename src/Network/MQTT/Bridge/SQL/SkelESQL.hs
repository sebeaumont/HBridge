module Network.MQTT.Bridge.SQL.SkelESQL where

-- Haskell module generated by the BNF converter

import Network.MQTT.Bridge.SQL.AbsESQL
import Network.MQTT.Bridge.SQL.ErrM

type Result = Err String

data ParsedProg = ParsedProg
  { sel :: [(String, Maybe String)]
  , whr :: Maybe [Cond]
  , mod :: Maybe [(String, Var)]
  } deriving (Eq, Ord, Show, Read)

--
transIdent :: Ident -> String
transIdent x = case x of
  Ident string -> string

--
transProgram :: Program -> ParsedProg
transProgram x = case x of
  SProgS s -> ParsedProg (transSelect s) Nothing Nothing
  SProgSW s w -> ParsedProg (transSelect s) (Just $ transWhere w) Nothing
  SProgSM s m -> ParsedProg (transSelect s) Nothing (Just $ transModify m)
  SProgSWM s w m -> ParsedProg (transSelect s) (Just $ transWhere w) (Just $ transModify m)

--
transSelect :: Select -> [(String, Maybe String)]
transSelect x = case x of
  SSel fields -> transFields fields

--
transWhere :: Where -> [Cond]
transWhere x = case x of
  SWhr conds -> transConds conds

--
transModify :: Modify -> [(String, Var)]
transModify x = case x of
  SMod mods -> transMods mods

--
transFields :: Fields -> [(String, Maybe String)]
transFields x = case x of
  EFields fs -> transField <$> fs

--
transConds :: Conds -> [Cond]
transConds x = case x of
  EConds conds -> transCond <$> conds

--
transMods :: Mods -> [(String, Var)]
transMods x = case x of
  EMods mods -> transMod <$> mods

--
transField :: Field -> (String, Maybe String)
transField x = case x of
  EField ident -> (transIdent ident, Nothing)
  EFieldAs ident1 ident2 -> (transIdent ident1, Just (transIdent ident2))

--
transCond :: Cond -> Cond
transCond = id
--
transBoolean :: Boolean -> Bool
transBoolean VTrue = True
transBoolean VFalse = False
--
transVar :: Var -> Var
transVar = id

--
transMod :: Mod -> (String, Var)
transMod x = case x of
  EMod ident var -> (transIdent ident, var)
