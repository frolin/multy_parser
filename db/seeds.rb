# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Оливки
# Оливковое масло
# - для салата
# - для жарки
# Закуски
# Орехи и сухофрукты
# - орехи
# - сухофрукты
# - семена
# Напитки
# Каши, супы, бобы
# Десерты
# - шоколад
# - пастила
# Масла растительные
# Мед
# Урбеч
# Снеки (перекусы)
# Специи
# Соусы
# Греческая косметика
# Суперфуды

# GOOGLE spreadsheet import
# https://docs.google.com/spreadsheets/d/1LZ8InEqMOXorxRQP-8rC-y64lmhW-SqGAkfKCPGqvdA/export?format=xlsx
# 1L1kUWSc6tCLymAKifgMKbAENJX6MIGt4zusIgRiOV8o


# Start with init Providers config
Provider.init

afon = Parser.find_by(slug: 'afon')
polezznoe = Parser.find_by(slug: 'polezznoe')

ImportProducts.new(parser: afon).import
ImportProducts.new(parser: polezznoe).import

spreadsheet ||= ImportService::GoogleSpreadsheet.new('1L1kUWSc6tCLymAKifgMKbAENJX6MIGt4zusIgRiOV8o').spreadsheet
# Imports::Xlsx.new(config: afon, spreadsheet: spreadsheet)
# ImportService::GoogleSpreadsheet.new(config: afon, spreadsheet: spreadsheet).process!

Option.delete_all; ImportProduct.delete_all; Import.delete_all; Product.delete_all; Parser.delete_all; Provider.delete_all
