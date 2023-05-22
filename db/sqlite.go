package db

import (
	"time"

	"github.com/glebarez/sqlite"
	"github.com/zeromicro/go-zero/core/logx"

	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func InitSQLiteDB(db_path string, cores ...interface{}) (*gorm.DB, error) {
	db := OpenSQLiteDB(db_path)
	for _, core := range cores {
		err := db.AutoMigrate(core)
		if err != nil {
			return nil, err
		}
	}

	return db, nil
}

// OpenSQLiteDB 打开sqlite数据库
func OpenSQLiteDB(db_path string) *gorm.DB {
	db, err := gorm.Open(sqlite.Open(db_path), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	for err != nil {
		logx.Debugf("Open SQLite BD file, will retry in 5 seconds, DB file path is ", db_path)
		time.Sleep(5 * time.Second)
		db, err = gorm.Open(sqlite.Open(db_path), &gorm.Config{})
	}

	return db
}
