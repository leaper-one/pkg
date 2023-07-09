package db

import (
	"time"

	"github.com/zeromicro/go-zero/core/logx"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

// https://github.com/go-gorm/postgres
// db, err := gorm.Open(postgres.New(postgres.Config{
// 	DSN: "user=gorm password=gorm dbname=gorm port=9920 sslmode=disable TimeZone=Asia/Shanghai",
// 	PreferSimpleProtocol: true, // disables implicit prepared statement usage
//   }), &gorm.Config{})

// InitPostgresDB 初始化Postgres数据库
func InitPostgresDB(dsn string, cores ...interface{}) (*gorm.DB, error) {
	db := OpenPostgresDB(dsn)
	for _, core := range cores {
		err := db.AutoMigrate(core)
		if err != nil {
			return nil, err
		}
	}

	return db, nil
}

// OpenPostgresDB 打开Postgres数据库
func OpenPostgresDB(dsn string) *gorm.DB {
	db, err := gorm.Open(postgres.New(postgres.Config{
		DSN:                  dsn,
		PreferSimpleProtocol: true, // disables implicit prepared statement usage
	}), &gorm.Config{})
	for err != nil {
		logx.Debugf("Open Postgres DB failed, will retry in 5 seconds, DSN is %+v", dsn)
		time.Sleep(5 * time.Second)
		db, err = gorm.Open(postgres.New(postgres.Config{
			DSN:                  dsn,
			PreferSimpleProtocol: true, // disables implicit prepared statement usage
		}), &gorm.Config{})
	}

	return db
}
