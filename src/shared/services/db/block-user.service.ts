import mongoose from 'mongoose';
import { PushOperator } from 'mongodb';
import { UserModel } from '@user/models/user.schema';

class BlockUserService {
  public async blockUser(userId: string, followerId: string): Promise<void> {
    const userIdObject = new mongoose.Types.ObjectId(userId);
    const followerIdObject = new mongoose.Types.ObjectId(followerId);

    UserModel.bulkWrite([
      {
        updateOne: {
          filter: { _id: userIdObject, blocked: { $ne: followerIdObject } },
          update: {
            $push: {
              blocked: followerIdObject
            } as PushOperator<Document>
          }
        }
      },
      {
        updateOne: {
          filter: { _id: followerIdObject, blockedBy: { $ne: userIdObject } },
          update: {
            $push: {
              blockedBy: userIdObject
            } as PushOperator<Document>
          }
        }
      }
    ]);
  }

  public async unblockUser(userId: string, followerId: string): Promise<void> {
    UserModel.bulkWrite([
      {
        updateOne: {
          filter: { _id: userId },
          update: {
            $pull: {
              blocked: new mongoose.Types.ObjectId(followerId)
            } as PushOperator<Document>
          }
        }
      },
      {
        updateOne: {
          filter: { _id: followerId },
          update: {
            $pull: {
              blockedBy: new mongoose.Types.ObjectId(userId)
            } as PushOperator<Document>
          }
        }
      }
    ]);
  }
}

export const blockUserService: BlockUserService = new BlockUserService();
