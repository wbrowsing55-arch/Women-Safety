import mongoose from 'mongoose';
const schema=new mongoose.Schema({category:{type:String,required:true,trim:true,maxlength:120},message:{type:String,required:true,trim:true,maxlength:1000},enabled:{type:Boolean,default:true,index:true},order:{type:Number,default:0}},{timestamps:true});
export default mongoose.model('ScratchCard',schema);
