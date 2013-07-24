module PodDB where

import           Control.Monad         (void, when)
import           Data.List             (sort)
import           Database.HDBC
import           Database.HDBC.Sqlite3
import           PodTypes
import           Scripts

-- | Establish a connection
connect :: FilePath -> IO Connection
connect fp =
    do dbh <- connectSqlite3 fp
       prepDB dbh
       return dbh

-- | Prepare the database
prepDB :: IConnection con => con -> IO ()
prepDB dbh = do
  tables <- getTables dbh
  print tables
  when ("podcasts" `notElem` tables) $ void (run dbh createTables [])
  when ("episodes" `notElem` tables) $ void (run dbh createEpisodes [])
  commit dbh

-- | Add a podcast
addPodcast :: IConnection conn => conn -> Podcast -> IO Podcast
addPodcast dbh podcast =
  handleSql errorHandler $ do
      run dbh insertPodcast [toSql (castURL podcast)]
      r <- quickQuery' dbh getPodcastIDByURL [toSql (castURL podcast)]
      case r of
        [[x]] -> return $ podcast { castId = fromSql x }
        y -> fail $ "addPodcast: unexpected result: " ++ show y
      where errorHandler e =
                fail $ "Error adding podcast; does this URL already exist?\n"
                           ++ show e

-- | Add an Episode
addEpisode :: IConnection conn => conn -> Episode -> IO ()
addEpisode dbh ep = void $ run dbh insertEpisode
                    [toSql (castId . epCast $ ep),
                     toSql (epURL ep),
                     toSql (epDone ep)]

-- | Update Podcast
updatePodcast :: IConnection conn => conn -> Podcast -> IO ()
updatePodcast dbh podcast = void $ run dbh updPodcast
                            [toSql (castURL podcast), toSql (castId podcast)]

-- | Update Epsiode
updateEpisode :: IConnection conn => conn -> Episode -> IO ()
updateEpisode dbh ep = void $ run dbh updEpisode
                       [ toSql (castId . epCast $ ep)
                        ,toSql (epURL ep)
                        ,toSql (epDone ep)
                        ,toSql (epId ep)
                       ]

-- | Remove Podcast
removePodcast :: IConnection conn => conn -> Podcast -> IO ()
removePodcast dbh podcast =
    do run dbh deleteEpById      [toSql (castId podcast)]
       run dbh deletePodcastById [toSql (castId podcast)]
       return ()

-- | Get Podcasts
getPodcasts :: IConnection conn => conn -> IO [Podcast]
getPodcasts dbh = do
  res <- quickQuery' dbh getAllPodcasts []
  return $ map convPodcastRow res

convPodcastRow :: [SqlValue] -> Podcast
convPodcastRow [svId, svURL] =
    Podcast { castId = fromSql svId,
              castURL = fromSql svURL }
convPodcastRow x = error $ "Can't convert podcast row " ++ show x

getPodcastEpisodes :: IConnection conn => conn -> Podcast -> IO [Episode]
getPodcastEpisodes dbh pc = do
  r <- quickQuery' dbh getEpisodeById [toSql (castId pc)]
  return $ map convEpRow r
    where convEpRow [svId, svURL, svDone] =
              Episode { epId   = fromSql svId
                      , epURL  = fromSql svURL
                      , epDone = fromSql svDone
                      , epCast = pc
                      }




