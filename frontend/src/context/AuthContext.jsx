import {createContext,useContext,useEffect,useState} from 'react';
import {api,getToken,setToken} from '../services/api';
const AuthContext=createContext(null);
export function AuthProvider({children}){
 const [user,setUser]=useState(null); const [loading,setLoading]=useState(Boolean(getToken()));
 useEffect(()=>{if(!getToken()){setLoading(false);return;} api('/auth/me').then(d=>setUser(d.user)).catch(()=>setToken(null)).finally(()=>setLoading(false));},[]);
 async function signIn(email,password){const d=await api('/auth/login',{method:'POST',body:JSON.stringify({email,password})});setToken(d.token);setUser(d.user);return d.user;}
 async function signUp(email,password){const d=await api('/auth/register',{method:'POST',body:JSON.stringify({email,password})});setToken(d.token);setUser(d.user);return d.user;}
 function signOut(){setToken(null);setUser(null);}
 return <AuthContext.Provider value={{user,loading,signIn,signUp,signOut}}>{children}</AuthContext.Provider>;
}
export const useAuth=()=>useContext(AuthContext);
