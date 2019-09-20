import moment from 'moment';

import {
    isAuth
} from '../middlewares/is-auth';

const resolvers = {
    Mutation: {
        updateProfile: async (parent, {
            data
        }, {
            req,
            prisma
        }, info) => {
            let user = null;
            try {
                user = await isAuth(req);
            } catch (error) {
                throw new Error(error.message);
            }

            if (user) {
                const {
                    uid,
                    email
                } = user;
                let profile = null;
                try {
                    profile = await prisma.mutation.upsertProfile(
                        {
                            where: {
                                uid,
                            },
                            update: {
                                ...data,
                                uid,
                                email,
                                is_complete: true,
                            },
                            create: {
                                ...data,
                                uid,
                                email,
                                is_complete: true,
                            }
                        }
                    );
                } catch (error) {
                    console.log(error);
                    throw new Error("400: bad request")
                }

                if (profile) {
                    return {
                        user_info: {
                            _id: profile._id,
                            firstname: profile.firstname,
                            lastname: profile.lastname,
                            birthday: profile.birthday,
                            gender: profile.gender,
                            address: profile.address,
                            phone_number: profile.phone_number,
                            email: profile.email,
                            avatar: profile.avatar,
                            role: profile.role,
                            is_complete: profile.is_complete,
                        }
                    }
                }
                throw new Error("400: bad request");
            }
        }
    }
};

export default resolvers;