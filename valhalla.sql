use valhalla;

CREATE TABLE players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  license VARCHAR(100) NOT NULL UNIQUE,
  firstname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  groups JSON NOT NULL DEFAULT (JSON_ARRAY()),
  skin JSON NOT NULL DEFAULT (JSON_OBJECT()),
  metadata JSON NOT NULL DEFAULT (JSON_OBJECT()),
  allowlist BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE players_bans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id INT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  expiration TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id)
  ON DELETE CASCADE
);

CREATE TABLE players_warnings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id INT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id)
  ON DELETE CASCADE
);