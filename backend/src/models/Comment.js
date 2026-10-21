import mongoose from 'mongoose';
const schema=new mongoose.Schema({user:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true},message:{type:String,required:true,trim:true,maxlength:2000},status:{type:String,enum:['pending','reviewed','hidden'],default:'pending',index:true}},{timestamps:true});
export default mongoose.model('Comment',schema);
