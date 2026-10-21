import mongoose from 'mongoose';
const schema=new mongoose.Schema({user:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true,unique:true,index:true}},{timestamps:true});
export default mongoose.model('CommunityInterest',schema);
