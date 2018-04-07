local C={}
C.handshake="RL"
C.port=4242

C.clientLogin="MW"
C.QuickSaveDir="quicksave/"
C.ServerSaveDir="server_save/"
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

C.editorActivate="e"
C.testCommand="t"
C.keyCastSpell="c"
C.keyInventory="i"
C.keyAbilities="a"
C.editorPlaceItem="space"
C.pickTarget=C.editorPlaceItem
C.keyDebugger="f11"

C.editorRows=8
C.editorCols=4

C.editorCurrentRow=1
C.editorCurrentCol=1

C.tileSize=32

C.lastId={}
C.lastId.player=1


return C