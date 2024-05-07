# import numpy as np
# import tensorflow as tf
# from tensorflow import keras
# import matplotlib.pyplot as plt
# import cv2
# import os


# # # GPU
# gpus = tf.config.experimental.list_physical_devices("GPU")
# if gpus:
#     tf.config.experimental.set_memory_growth(gpus[0], True)
#     tf.config.set_visible_devices([gpus[0]], "GPU")
# # tf.config.set_visible_devices([], 'GPU') # force run on cpu
# def add_square(img, center, width):
#   start_point = (center[0]-width, center[1]-width)
#   end_point   = (center[0]+width, center[1]+width)
#   cv2.rectangle(img, start_point, end_point, random_color(),cv2.FILLED)
# def create_data_sample(num_shapes, height, width):
#   img = np.ones((height, width, 3))
#   label = np.ones((height, width, 1))
#   for _ in range(num_shapes):
#     x = int(np.random.rand()*width)
#     y = int(np.random.rand()*height)
#     if np.random.rand() > 0.5:
#       cv2.circle(img, (x,y), int(np.ceil(width*0.05)), random_color(), cv2.FILLED)
#       cv2.circle(label, (x,y), int(np.ceil(width*0.02)), (1,1,1), cv2.FILLED)
#     else: 
#       add_square(img, (x,y), int(np.ceil(width*0.05*0.7)))
#   return img, label
# def test_batch(num_shapes, height, width):
#   img, label = create_data_sample(num_shapes, height, width)
#   return np.expand_dims(img,0), np.expand_dims(label,0)
     
# def grayscale_image(img):
#   return np.expand_dims((img[:,:,0] + img[:,:,1] + img[:,:,2])/3,2)
     

# # (128,128,1) --> (128,128,3)
# def to_three_channels(img):
#   return np.squeeze(np.stack((img,img,img), 2))
     

# def random_color():
#   return np.random.rand(3)
     

# def show_sample(img, label):
#   figure, axis = plt.subplots(1,2)
#   axis[0].imshow(img)
#   axis[1].imshow(to_three_channels(label))
     

# def show_batch(img, label):
#   show_sample(img[0,:,:,:],label[0,:,:,:])
     

# img_shape = (512,384,3)
# img, label = create_data_sample(10, img_shape[0], img_shape[1])

# show_sample(img, label)

# img, label = test_batch(10, img_shape[0], img_shape[1])
# print(img.shape, label.shape)
# show_batch(img, label)

# #l2 = keras.regularizers.l2(1e-5)
# l2 = None
# inputs = keras.Input(shape=img_shape)
# conv1 = keras.layers.Conv2D(16,5,padding='same',activation='relu',kernel_initializer='glorot_normal',kernel_regularizer=l2)(inputs)
# conv1 = keras.layers.BatchNormalization(momentum=0.99)(conv1)
# conv2 = keras.layers.Conv2D(32,5,padding='same',activation='relu',kernel_initializer='glorot_normal',kernel_regularizer=l2)(conv1)
# conv2 = keras.layers.BatchNormalization(momentum=0.99)(conv2)
# outputs = keras.layers.Conv2D(1,5,padding='same',activation='relu',kernel_initializer='glorot_normal',kernel_regularizer=l2)(conv2)
# model = keras.Model(inputs=inputs, outputs=outputs)
# model.summary()

# def loss_function(y_true, y_pred):
#   squared_diff = tf.square(y_true - y_pred)
#   return tf.reduce_mean(squared_diff)
# x_list = []
# y_list = []
# numbertotraindata=100
# for i in range(numbertotraindata):
#   x,y  = create_data_sample(10, img_shape[0], img_shape[1])
#   x_list.append(x)
#   y_list.append(y)
# x_list = np.array(x_list)
# y_list = np.array(y_list)

# i = 3
# # show_sample(x_list[i], y_list[i])

# x_list.shape

# opt = keras.optimizers.Adam(learning_rate=1e-4)
# model.compile(optimizer=opt,loss=loss_function)
# epochnumber=10
# barchsize= 5
# filename ='circles'+str(numbertotraindata)+'_b'+str(barchsize)+'_'+str(epochnumber)+'epoch'
# filename+='.h5'
# if os.path.isfile(filename):
#     model.load_weights(filename)
# else:
#     model.fit(x_list,y_list,batch_size=barchsize,epochs=epochnumber)
#     model.save(filename)

# img, label = test_batch(10, img_shape[0], img_shape[1])
# # img = cv2.imread('cct1.jpeg')
# # resized = img.copy()
# # resized.resize((512,384,3),refcheck=False)

# # # img.reshape((None,32, 1536,3))
# # img=resized
# # img = img[None,:]
# # plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
# # plt.show()
# # img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
# # show_batch(img,label)
# y_pred = model.predict(img)
# print(y_pred.max())
# # plt.title("asdasd")
# # plt.imshow(cv2.cvtColor(y_pred, cv2.COLOR_BGR2RGB))
# # plt.show()
# show_batch(img, y_pred)

# loss_function(y_pred, label)
# x=input("press any key to exts")