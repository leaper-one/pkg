package db

import (
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type DB struct {
	Write *gorm.DB
	Read  *gorm.DB
}

func (db *DB) Update() *gorm.DB {
	return db.Write
}

func (db *DB) View() *gorm.DB {
	return db.Read
}

func (db *DB) Debug() *DB {
	return &DB{
		Write: db.Write.Debug(),
		Read:  db.Read.Debug(),
	}
}

func (db *DB) Begin() *DB {
	tx := db.Write.Begin()
	return &DB{
		Write: tx,
		Read:  db.Read,
	}
}

func (db *DB) Rollback() error {
	return db.Write.Rollback().Error
}

func (db *DB) Commit() error {
	return db.Write.Commit().Error
}

func (db *DB) RollbackUnlessCommitted() {
	if err := db.Write.Rollback().Error; err != nil {
		logrus.WithError(err).Error("DB: RollbackUnlessCommitted")
	}
}

func (db *DB) Tx(fn func(tx *DB) error) error {
	tx := db.Begin()
	defer tx.RollbackUnlessCommitted()

	if err := fn(tx); err != nil {
		return err
	}

	return tx.Commit()
}
