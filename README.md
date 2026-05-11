# 'superLazyScript'

added new skin, font, and superwow interrupt support (so now player will not try to interrupt a completed cast)
made active=msg activeframe actually big and readable. changed minion texture to a white glow. added new help tab for previously undocumented features. fixed warrior targethp bug caused by misnamed variable.

changes in modules/

<img width="1326" height="725" alt="image" src="https://github.com/user-attachments/assets/c35763b7-d8fc-46c2-81b7-1b573aadb17c" />

### new masks

https://github.com/user-attachments/assets/207a64f0-74c5-448a-8080-0ddf2a785ba8

ifAutoShotSafe requires Quiver and is a safe way to cast hunter spells without ever clipping the reload timer.

Script used:
```
aimed-ifReloadTimer>1.5s-ifplayerHasBuffTitle=Lock and Load
arcane-ifplayerHasDebuffTitle=Enchanted Ammunition-ifAutoShotSafe-ifGotTalent=Experimental Ammunition
serpent-ifplayerHasDebuffTitle=Poisonous Ammunition-ifAutoShotSafe
multi-ifplayerHasDebuffTitle=Explosive Ammunition-ifAutoShotSafe
aimed-ifReloadTimer>2.5s-ifNotInCombat-ifGotTalent=Aimed Shot
action=Steady Shot-ifReloadTimer>1.5s
```

# LazyScript

Look at [Wiki](https://github.com/laytya/LazyScript/wiki) for more info






