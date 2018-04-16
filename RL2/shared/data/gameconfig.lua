local C={}

C.version=2
C.handshake="RL"
C.port=4242

C.clientLogin="MW"
C.WorldSaveName="world"

--C.ViewRadiusTilesX=5 -- -> player.fov 
-- C.ViewRadiusTilesY=4

C.moveUpRight="kp9"
C.moveLeft="kp4"
C.moveUpLeft="kp7"
C.moveRight="kp6"
C.moveUp="kp8"
C.moveDownRight="kp3"
C.moveDown="kp2"
C.moveDownLeft="kp1"
C.climbDown="."
C.pickupItem=","

C.editorActivate="e"
C.testCommand="t"
C.keyCastSpell="c"
C.keyInventory="i"
C.keyAbilities="a"
C.editorPlaceItem="space"
C.editorDeleteItem="delete"
C.editorNextPage="pagedown"
C.editorPrevPage="pageup"
C.pickTarget=C.editorPlaceItem
C.keyDebugger="f11"
C.keyOpenOptions="f10"
C.optionMute="m"
C.optionNextTrack="n"

C.editorRows=10
C.editorCols=10

C.editorCurrentRow=1
C.editorCurrentCol=1

C.tileSize=32

C.isMusicEnabled=true


return C