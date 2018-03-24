import React from 'react';
import helpers from 'foremanReact/common/helpers';
import { headerFormat, cellFormat } from 'foremanReact/components/common/table';
import { Icon } from 'patternfly-react';

export const columns = [
  {
    property: 'id',
    header: {
      label: __('Name'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [
        (value, { rowData }) => (
          <td>
            <a href={helpers.urlBuilder('subscriptions', '', rowData.id)}>
              {rowData.name}
            </a>
          </td>
        ),
      ],
    },
  },
  {
    property: 'product_id',
    header: {
      label: __('SKU'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [cellFormat],
    },
  },
  {
    property: 'contract_number',
    header: {
      label: __('Contract'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [cellFormat],
    },
  },
  // TODO: use date formatter from tomas' PR
  {
    property: 'start_date',
    header: {
      label: __('Start Date'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [cellFormat],
    },
  },
  {
    property: 'end_date',
    header: {
      label: __('End Date'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [cellFormat],
    },
  },
  {
    property: 'virt_who',
    header: {
      label: __('Requires Virt-Who'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [
        cell => (
          <td>
            <Icon type="fa" name={cell.virt_who ? 'check' : 'minus'} />
          </td>
        ),
      ],
    },
  },
  {
    property: 'consumed',
    header: {
      label: __('Entitlements'),
      formatters: [headerFormat],
    },
    cell: {
      formatters: [
        (value, { rowData }) => (
          <td>
            {rowData.available === -1 ? __('Unlimited') : rowData.consumed }
          </td>
        ),
      ],
    },
  },
];

export default columns;
