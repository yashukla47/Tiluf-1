import { NewGravatar, UpdatedGravatar } from '../generated/Gravity/Gravity'
import { Gravatar } from '../generated/schema'

export function handleCreateUser(event: createUser): void {
  let user = new User(event.params.id.toHex())
  user.userName = event.params.userName
  user.address = event.params.add
  user.mobile = event.params.mobile
  user.picUrl = event.params.pic
  user.role = event.params.role
  user.save()
}

export function handleUpdateUser(event: updateUser): void {
  let id = event.params.id.toHex()
  let user = User.load(id)
  if (user == null) {
    user = new User(id)
  }
  user.mobile = event.params.mobile
  user.picUrl = event.params.pic
  user.role = event.params.role
  user.save()
}
