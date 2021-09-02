<template>
  <table>
    <thead>
      <tr>
        <th>Имя поля</th>
        <th>Тип поля</th>
        <th>....</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(field, index) in fields" :key="index">
        <td><input :name="'field_name_' + index" type="text" v-model="field.name"/></td>
        <td>
          <div class="input-field col s12">
            <select :name="'field_type_' + index" @change="onTypeSelect($event, index)">
              <option v-for="type in typesList" :selected="field.type==type" :key="type" :value="type">
                {{ type }}
              </option>
            </select>
          </div>
        </td>
        <td>
          <button
            name="remove_field"
            class="btn-floating btn-small waves-effect waves-light red"
            title="Удалить поле"
            type="button"
            @click="removeField(index)"
          >
            <i class="material-icons">remove</i>
          </button>
        </td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td>
          <button
            name="add_field"
            class="btn-floating btn-small waves-effect waves-light green"
            title="Добавить поле"
            type="button"
            @click="addField"
          >
            <i class="material-icons">add</i>
          </button>
        </td>
      </tr>

    </tbody>
  </table>
</template>

<script>
import initMaterialize from '../init'

export default {
  props:  {
    types: {
      type: String,
      required: true,
    }
  },

  data: function () {
    return {
      fields: [],
    };
  },

  methods: {
    addField: function () {
      this.fields.push({
        name: '',
        type: '',
      })
    },

    removeField: function (index) {
      this.fields.splice(index, 1);
    },

    onTypeSelect: function (event, index) {
      this.fields[index].type = this.selectedOption(event.target.children).value
    },

    selectedOption(optionsCollection) {
      for (let i = 0; i < optionsCollection.length; i++) {
        const option = optionsCollection[i]
        if (option.selected) {
          return option
        }
      }
    },

    initSelects: function () {
      initMaterialize()
    },
  },

  computed: {
    typesList: function () {
      return this.types.match(/\w+/g);
    },
  },

  updated () {
    this.initSelects()
  },
}
</script>
