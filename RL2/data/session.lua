local _={}

_.rootState=nil
_.frame=0
_.isServer=Lume.find(arg, "server")~=nil or Lume.find(arg, "s")~=nil
_.isEditor=(not _.isServer) and (Lume.find(arg, "editor")~=nil or Lume.find(arg, "e")~=nil)
_.keyPressedListeners={} -- это уйдёт, инпут пустить по цепочке стейтов, начиная с нижнего
_.updateListeners={}
_.keysDown={}
_.saveDir=nil

return _