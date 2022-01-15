## Описание
Патчер игровых файлов Borderlands с целью уменьшения размера шрифта названия в карточках оружия, так как некоторые названия вместе с префиксами могут занимать больше двух строк.

Для работы необходима предварительная распаковка с помощью decompress.exe с сайта [Gildor.org](http://www.gildor.org/downloads).

## Ключи запуска
`-nolog` отключение журналирования в файл umapPatchLog.txt

`-rollback` откат изменений графического интерфейса. Откат производится только в части интерфейса, обратного сжатия файлов не произойдет. Для возврата к исходному состоянию файла необходима проверка кэша Steam или переустановка игры.

## Изменения в GFX-файлах

### W_Startup.INT

__карточки оружия в сундуках и на земле__
inworld_ui weapon_card

```
sprite  184 object  99  scalex 52428->40000
                        scaley 65536->50000

                    99  xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 945 -> 1085
```

__награда за задание__
menus_mission mission_interface
```
sprite  382 object  295 scalex 52428->40000
                        scaley 65536->50000

                    295 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 945 -> 1085
```

### WillowGame.upk

__инвентарь игрока__
menus_ingame_redux status_menu
```
sprite  515 object  470 scalex 52428->40000
                        scaley 65536->50000

                    470 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 945 -> 1085

sprite  590 object  581 scalex 52428->40000
                        scaley 65536->50000

                    581 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 945 -> 1085
```

### DLC\DLC2\Maps\W_dlc2_lobby_p.umap

__банк__
menus_bank bank
```
sprite  329 object  236 scalex 52428->40000
                        scaley 65536->50000

                    236 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 960 -> 1085

sprite  408 object  398 scalex 52428->40000
                        scaley 65536->50000

                    398 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 930 -> 1085
```

### .umap файлы

__интерфейс торговых автоматов__
menus_vending vending_machine

- красные
```
sprite  342 object  252 scalex 52428->40000
                        scaley 65536->50000
                        
                    252 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 955 -> 1100

sprite  418 object  409 scalex 52428->40000
                        scaley 65536->50000

                    409 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 960 -> 1100
```
- зеленые
```
sprite  586 object  569 scalex 52428->40000
                        scaley 65536->50000

                    569 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 960 -> 1100

sprite  621 object  612 scalex 52428->40000
                        scaley 65536->50000

                    612 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 960 -> 1100
```
- серые
```
sprite  766 object  749 scalex 52428->40000
                        scaley 65536->50000

                    749 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 960 -> 1100

sprite  801 object  792 scalex 52428->40000
                        scaley 65536->50000

                    792 xmax -6414 -> 8190
                        ymin -40 -> 100
                        ymax 960 -> 1100
```

### Дополнительно найденные карточки
Карточки, найденные в интерфейсе, но эффект от их изменения не обнаружен.

__weaponcard__ в interface\inworld_ui.upk
```
sprite  184 object  99  scalex 52428->10000
```
__menus_ingame_redux status_menu__ в interface\inworld_ui.upk
```
sprite  515 object  470 scalex 52428->40000
                    514 scalex 52428->40000

sprite  590 object  581 scalex 52428->40000
                    589 scalex 52428->40000

sprite  597 object  514 scalex 52428->40000
```

__menus_ingame_redux status_menu__ в WillowGame.upk
```
sprite  515 object  470 scalex 52428->40000
                    514 scalex 52428->40000

sprite  590 object  581 scalex 52428->40000
                    589 scalex 52428->40000

sprite  597 object  514 scalex 52428->40000
```
