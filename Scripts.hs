module Scripts where

-- | Creation Scripts
createTables :: String
createTables = "CREATE TABLE podcasts (\
               \castid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
               \castURL TEXT NOT NULL UNIQUE)"

createEpisodes :: String
createEpisodes = "CREATE TABLE episodes (\
                 \epid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                 \epcastid INTEGER NOT NULL,\
                 \epurl TEXT NOT NULL,\
                 \epdone INTEGER NOT NULL,\
                 \UNIQUE(epcastid, epurl),\
                 \UNIQUE(epcastid, epid))"

-- | Insertion Scripts
insertPodcast :: String
insertPodcast = "INSERT INTO podcasts (castURL) VALUES (?)"

-- | Selection Scripts
getPodcastIDByURL :: String
getPodcastIDByURL = "SELECT castid FROM podcasts WHERE castURL = ?"

insertEpisode :: String
insertEpisode = "INSERT OR IGNORE INTO episodes (epCastId, epURL, epDone) \
                \VALUES (?, ?, ?)"

updPodcast :: String
updPodcast = "UPDATE podcasts SET castURL = ? WHERE castId = ?"

updEpisode :: String
updEpisode = "UPDATE episodes SET epCastId = ?, epURL = ?, epDone = ? \
             \WHERE epId = ?"

getAllPodcasts :: String
getAllPodcasts = "SELECT castid, casturl FROM podcasts ORDER BY castid"

getEpisodeById :: String
getEpisodeById = "SELECT epId, epURL, epDone FROM episodes WHERE epCastId = ?"

-- | Deletion
deleteEpById :: String
deleteEpById = "DELETE FROM episodes WHERE epcastid = ?"

deletePodcastById :: String
deletePodcastById = "DELETE FROM podcasts WHERE castid = ?"









