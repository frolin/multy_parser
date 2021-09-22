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

ImportProducts.new(slug: 'afon').import
ImportProducts.new(slug: 'polezznoe').import

Option.delete_all; ImportProduct.delete_all; Import.delete_all; Product.delete_all; Parser.delete_all; Provider.delete_all
